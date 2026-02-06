#!/bin/bash
# Dendrite Evaluator - Run golden task suite
# Usage: bash .claude/eval/run-eval.sh [--fast] [--task <id>] [--tag <tag>]
set -e

EVAL_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$EVAL_DIR/../.." && pwd)"
TASKS_FILE="$EVAL_DIR/golden-tasks.json"
LOG_DIR="$EVAL_DIR/logs"
RESULTS_DIR="$EVAL_DIR/results"

mkdir -p "$LOG_DIR" "$RESULTS_DIR"

cd "$PROJECT_DIR"

# Parse args
FILTER_TASK=""
FILTER_TAG=""
FAST_MODE=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --fast) FAST_MODE=true; shift ;;
    --task) FILTER_TASK="$2"; shift 2 ;;
    --tag) FILTER_TAG="$2"; shift 2 ;;
    *) shift ;;
  esac
done

# Run evaluation
python3 -c "
import json, subprocess, sys, os, time, re
from datetime import datetime

with open('$TASKS_FILE') as f:
    data = json.load(f)

tasks = data['tasks']
filter_task = '$FILTER_TASK'
filter_tag = '$FILTER_TAG'
fast_mode = $( [ "$FAST_MODE" = true ] && echo "True" || echo "False" )

# Apply filters
if filter_task:
    tasks = [t for t in tasks if t['id'] == filter_task]
elif filter_tag:
    tasks = [t for t in tasks if filter_tag in t.get('tags', [])]
elif fast_mode:
    import random
    seed = int(datetime.now().strftime('%Y%m%d'))
    random.seed(seed)
    critical = [t for t in tasks if 'critical' in t.get('tags', [])]
    rest = [t for t in tasks if 'critical' not in t.get('tags', [])]
    sample_size = max(1, len(rest) * 10 // 100)
    sampled = random.sample(rest, sample_size)
    tasks = critical + sampled

total = len(tasks)
passed = 0
failed = 0
results = []
start_time = time.time()

for task in tasks:
    tid = task['id']
    name = task['name']
    task_start = time.time()
    status = 'PASS'
    details = ''

    try:
        if task['type'] == 'assertion':
            for assertion in task['test']['assertions']:
                atype = assertion['type']

                if atype == 'file_exists':
                    if not os.path.exists(assertion['target']):
                        status = 'FAIL'
                        details = assertion.get('message', f'{assertion[\"target\"]} not found')
                        break

                elif atype == 'file_contains':
                    target = assertion['target']
                    pattern = assertion['pattern']
                    expected = assertion.get('expected', True)
                    if os.path.exists(target):
                        with open(target) as f:
                            content = f.read()
                        found = pattern in content
                        if found != expected:
                            status = 'FAIL'
                            neg = 'not ' if expected else ''
                            details = assertion.get('message', 'Pattern ' + pattern + ' ' + neg + 'found in ' + target)
                            break
                    else:
                        status = 'FAIL'
                        details = f'{target} does not exist'
                        break

                elif atype == 'command_exit_code':
                    result = subprocess.run(assertion['target'], shell=True, capture_output=True, timeout=30)
                    expected_code = int(assertion['expected'])
                    if result.returncode != expected_code:
                        status = 'FAIL'
                        details = assertion.get('message', f'Command exited with {result.returncode}, expected {expected_code}')
                        break

                elif atype == 'command_output':
                    result = subprocess.run(assertion['target'], shell=True, capture_output=True, text=True, timeout=30)
                    pattern = assertion['pattern']
                    expected = assertion.get('expected', True)
                    found = pattern in result.stdout
                    if found != expected:
                        status = 'FAIL'
                        details = assertion.get('message', f'Pattern \"{pattern}\" not in command output')
                        break

        elif task['type'] == 'script':
            script_path = task['test']['script']
            if not os.path.exists(script_path):
                status = 'FAIL'
                details = f'Validator script not found: {script_path}'
            else:
                result = subprocess.run(['bash', script_path], capture_output=True, text=True, timeout=30)
                if result.returncode != 0:
                    status = 'FAIL'
                    details = result.stdout.strip() or result.stderr.strip()

        elif task['type'] == 'oracle':
            oracle = task['test']['oracle']
            known_good = subprocess.run(oracle['known_good'], shell=True, capture_output=True, text=True, timeout=30)
            actual = subprocess.run(oracle['actual'], shell=True, capture_output=True, text=True, timeout=30)

            comparator = oracle.get('comparator', 'exact')
            if comparator == 'exact':
                if known_good.stdout.strip() != actual.stdout.strip():
                    status = 'FAIL'
                    details = f'Expected: {known_good.stdout.strip()}, Got: {actual.stdout.strip()}'
            elif comparator == 'contains':
                if known_good.stdout.strip() not in actual.stdout.strip():
                    status = 'FAIL'
                    details = f'Expected output to contain: {known_good.stdout.strip()}'

    except subprocess.TimeoutExpired:
        status = 'FAIL'
        details = 'Timeout (30s)'
    except Exception as e:
        status = 'ERROR'
        details = str(e)

    duration_ms = int((time.time() - task_start) * 1000)

    if status == 'PASS':
        passed += 1
    else:
        failed += 1

    results.append({
        'task_id': tid,
        'name': name,
        'status': status,
        'duration_ms': duration_ms,
        'details': details,
        'tags': task.get('tags', [])
    })

total_duration = round(time.time() - start_time, 1)
score = round(passed / total * 100, 1) if total > 0 else 0
avg_ms = round(sum(r['duration_ms'] for r in results) / total) if total > 0 else 0

# Stdout summary (LLM-friendly)
mode = 'fast' if fast_mode else ('tag:' + filter_tag if filter_tag else ('task:' + filter_task if filter_task else 'full'))
print(f'EVAL {passed}/{total} PASS | {failed} FAIL | {score}% | {avg_ms}ms avg | mode={mode}')

for r in results:
    if r['status'] != 'PASS':
        print(f'{r[\"status\"]} {r[\"task_id\"]} {r[\"name\"]} \"{r[\"details\"]}\"')

# Save detailed log
timestamp = datetime.now().strftime('%Y-%m-%dT%H-%M-%S')
log_data = {
    'run_id': f'eval-{timestamp}',
    'timestamp': datetime.now().isoformat(),
    'mode': mode,
    'duration_seconds': total_duration,
    'summary': {
        'total': total,
        'passed': passed,
        'failed': failed,
        'score': score / 100
    },
    'results': results
}

log_file = f'$LOG_DIR/{timestamp}.json'
with open(log_file, 'w') as f:
    json.dump(log_data, f, indent=2)

print(f'Details: {log_file}')

# Update metrics
metrics_file = '$EVAL_DIR/metrics.json'
metrics = {'history': []}
if os.path.exists(metrics_file):
    with open(metrics_file) as f:
        metrics = json.load(f)

metrics['history'].append({
    'date': datetime.now().strftime('%Y-%m-%d'),
    'run_id': f'eval-{timestamp}',
    'score': score / 100,
    'total': total,
    'passed': passed,
    'failed': failed,
    'mode': mode
})

# Keep last 50 entries
metrics['history'] = metrics['history'][-50:]

scores = [h['score'] for h in metrics['history']]
metrics['best_score'] = max(scores)
metrics['latest_score'] = scores[-1]

with open(metrics_file, 'w') as f:
    json.dump(metrics, f, indent=2)

sys.exit(1 if failed > 0 else 0)
"
