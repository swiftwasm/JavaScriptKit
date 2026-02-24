// @ts-check

/**
 * Returns the complete HTML for the live dashboard.
 * Self-contained: inline CSS + JS, SSE for live updates.
 * @returns {string}
 */
export function dashboardHTML() {
  return /* html */ `<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>BridgeJS Fuzzer</title>
<style>
  :root {
    --bg: #0d1117; --surface: #161b22; --border: #30363d;
    --text: #e6edf3; --dim: #8b949e; --accent: #58a6ff;
    --green: #3fb950; --red: #f85149; --yellow: #d29922; --purple: #bc8cff;
  }
  * { box-sizing: border-box; margin: 0; padding: 0; }
  body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif;
         background: var(--bg); color: var(--text); padding: 20px; line-height: 1.5; }
  h1 { font-size: 1.4rem; margin-bottom: 4px; }
  h2 { font-size: 1.1rem; color: var(--dim); margin-bottom: 12px; font-weight: 400; }
  .header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; }
  .header-left h2 { margin-bottom: 0; }
  .status-badge { padding: 4px 12px; border-radius: 12px; font-size: 0.85rem; font-weight: 600; }
  .status-badge.running { background: rgba(63,185,80,0.15); color: var(--green); }
  .status-badge.paused  { background: rgba(210,153,34,0.15); color: var(--yellow); }
  .status-badge.stopped { background: rgba(139,148,158,0.15); color: var(--dim); }

  .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 12px; margin-bottom: 20px; }
  .card { background: var(--surface); border: 1px solid var(--border); border-radius: 8px; padding: 16px; }
  .card-label { font-size: 0.8rem; color: var(--dim); text-transform: uppercase; letter-spacing: 0.05em; }
  .card-value { font-size: 1.8rem; font-weight: 700; margin-top: 4px; }
  .card-value.green { color: var(--green); }
  .card-value.red { color: var(--red); }

  .section { background: var(--surface); border: 1px solid var(--border); border-radius: 8px;
             padding: 16px; margin-bottom: 16px; }
  .section-title { font-size: 0.95rem; font-weight: 600; margin-bottom: 12px; }

  .controls { display: flex; gap: 8px; }
  .btn { padding: 6px 16px; border-radius: 6px; border: 1px solid var(--border); background: var(--surface);
         color: var(--text); cursor: pointer; font-size: 0.85rem; }
  .btn:hover { border-color: var(--accent); }
  .btn.active { background: var(--accent); color: #000; border-color: var(--accent); }

  /* Coverage heatmap */
  .heatmap { display: flex; flex-wrap: wrap; gap: 6px; }
  .heatmap-cell { padding: 6px 10px; border-radius: 4px; font-size: 0.8rem; font-family: monospace;
                  background: rgba(88,166,255,0.1); border: 1px solid var(--border); }
  .heatmap-cell .count { font-weight: 700; color: var(--accent); }

  /* Log */
  .log { max-height: 400px; overflow-y: auto; font-family: monospace; font-size: 0.82rem;
         line-height: 1.6; }
  .log-entry { padding: 2px 0; border-bottom: 1px solid var(--border); display: flex; gap: 8px; }
  .log-entry .seed { color: var(--dim); min-width: 80px; }
  .log-entry .result { font-weight: 600; }
  .log-entry .result.ok { color: var(--green); }
  .log-entry .result.fail { color: var(--red); }
  .log-entry .phase { color: var(--yellow); }

  /* Failures table */
  table { width: 100%; border-collapse: collapse; font-size: 0.85rem; }
  th { text-align: left; color: var(--dim); font-weight: 500; padding: 6px 8px;
       border-bottom: 1px solid var(--border); }
  td { padding: 6px 8px; border-bottom: 1px solid var(--border); }
  tr:hover td { background: rgba(88,166,255,0.05); }
  td a { color: var(--accent); text-decoration: none; }
  td a:hover { text-decoration: underline; }

  /* Failure detail modal */
  .modal-backdrop { position: fixed; top: 0; left: 0; right: 0; bottom: 0;
                    background: rgba(0,0,0,0.7); display: none; z-index: 100;
                    justify-content: center; align-items: center; }
  .modal-backdrop.visible { display: flex; }
  .modal { background: var(--surface); border: 1px solid var(--border); border-radius: 8px;
           width: 90%; max-width: 900px; max-height: 85vh; overflow-y: auto; padding: 20px; }
  .modal h3 { margin-bottom: 12px; }
  .modal pre { background: var(--bg); border: 1px solid var(--border); border-radius: 4px;
               padding: 12px; overflow-x: auto; font-size: 0.82rem; margin-bottom: 12px;
               max-height: 300px; overflow-y: auto; white-space: pre-wrap; word-wrap: break-word; }

  .modal .close { float: right; cursor: pointer; color: var(--dim); font-size: 1.2rem; }
  .modal .close:hover { color: var(--text); }
  .tab-bar { display: flex; gap: 4px; margin-bottom: 8px; }
  .tab { padding: 4px 12px; border-radius: 4px; cursor: pointer; font-size: 0.82rem;
         background: var(--bg); color: var(--dim); border: 1px solid var(--border); }
  .tab.active { background: var(--accent); color: #000; border-color: var(--accent); }
</style>
</head>
<body>
  <div class="header">
    <div class="header-left">
      <h1>BridgeJS Fuzzer</h1>
      <h2>Operation-based fuzz testing for JavaScriptKit BridgeJS</h2>
    </div>
    <div style="display:flex;align-items:center;gap:12px">
      <span id="statusBadge" class="status-badge stopped">Stopped</span>
      <div class="controls">
        <button class="btn" id="btnPause" onclick="pause()">Pause</button>
        <button class="btn" id="btnResume" onclick="resume()">Resume</button>
      </div>
    </div>
  </div>

  <div class="grid">
    <div class="card">
      <div class="card-label">Iterations</div>
      <div class="card-value" id="statIter">0</div>
    </div>
    <div class="card">
      <div class="card-label">Failures</div>
      <div class="card-value red" id="statFail">0</div>
    </div>
    <div class="card">
      <div class="card-label">Throughput</div>
      <div class="card-value" id="statThroughput">0 <small style="font-size:0.5em;color:var(--dim)">iter/s</small></div>
    </div>
    <div class="card">
      <div class="card-label">Elapsed</div>
      <div class="card-value" id="statElapsed">0s</div>
    </div>
    <div class="card">
      <div class="card-label">Current Seed</div>
      <div class="card-value" id="statSeed" style="font-size:1.2rem">—</div>
    </div>
  </div>

  <div class="section">
    <div class="section-title">Type Coverage</div>
    <div class="heatmap" id="heatmap"><em style="color:var(--dim)">Waiting for data...</em></div>
  </div>

  <div class="section">
    <div class="section-title">Failures</div>
    <table>
      <thead><tr><th>ID</th><th>Phase</th><th>Seed</th><th>Types</th><th>Time</th></tr></thead>
      <tbody id="failureTable"></tbody>
    </table>
    <div id="noFailures" style="color:var(--dim);padding:12px;text-align:center">No failures yet</div>
  </div>

  <div class="section">
    <div class="section-title">Recent Results</div>
    <div class="log" id="log"></div>
  </div>

  <div class="modal-backdrop" id="modal">
    <div class="modal">
      <span class="close" onclick="closeModal()">&times;</span>
      <h3 id="modalTitle">Failure Detail</h3>
      <div class="tab-bar" id="modalTabs"></div>
      <pre id="modalContent"></pre>
    </div>
  </div>

<script type="module">
import { AnsiUp } from 'https://cdn.jsdelivr.net/npm/ansi_up@6/ansi_up.min.js';
const $ = (id) => document.getElementById(id);

// ---- SSE ----
const evtSource = new EventSource('/api/events');

evtSource.addEventListener('status', (e) => {
  const d = JSON.parse(e.data);
  updateStatus(d);
});

evtSource.addEventListener('result', (e) => {
  const d = JSON.parse(e.data);
  addLogEntry(d);
});

evtSource.addEventListener('message', (e) => {
  try {
    const d = JSON.parse(e.data);
    if (d.totalIterations !== undefined) updateStatus(d);
  } catch {}
});

function updateStatus(d) {
  $('statIter').textContent = d.totalIterations;
  $('statFail').textContent = d.totalFailures;
  $('statThroughput').innerHTML = d.throughput + ' <small style="font-size:0.5em;color:var(--dim)">iter/s</small>';
  $('statElapsed').textContent = formatElapsed(parseFloat(d.elapsed));
  $('statSeed').textContent = d.currentSeed;

  const badge = $('statusBadge');
  badge.className = 'status-badge ' + (d.paused ? 'paused' : d.running ? 'running' : 'stopped');
  badge.textContent = d.paused ? 'Paused' : d.running ? 'Running' : 'Stopped';
}

function formatElapsed(secs) {
  if (secs < 60) return secs.toFixed(0) + 's';
  if (secs < 3600) return (secs/60).toFixed(1) + 'm';
  return (secs/3600).toFixed(1) + 'h';
}

function addLogEntry(d) {
  const log = $('log');
  const el = document.createElement('div');
  el.className = 'log-entry';
  el.innerHTML = '<span class="seed">seed ' + d.seed + '</span>'
    + '<span class="result ' + (d.ok ? 'ok' : 'fail') + '">' + (d.ok ? 'OK' : 'FAIL') + '</span>'
    + (d.phase ? '<span class="phase">' + d.phase + '</span>' : '');
  log.prepend(el);
  // Keep max 200 entries in DOM
  while (log.children.length > 200) log.removeChild(log.lastChild);
}

// ---- Controls ----
function pause() { fetch('/api/control/pause', { method: 'POST' }); }
function resume() { fetch('/api/control/resume', { method: 'POST' }); }

// ---- Coverage ----
async function refreshCoverage() {
  try {
    const data = await (await fetch('/api/coverage')).json();
    const heatmap = $('heatmap');
    if (Object.keys(data).length === 0) return;
    const sorted = Object.entries(data).sort((a, b) => b[1] - a[1]);
    heatmap.innerHTML = sorted.map(([kind, count]) => {
      const opacity = Math.min(1, 0.2 + (count / Math.max(...sorted.map(s => s[1]))) * 0.8);
      return '<div class="heatmap-cell" style="background:rgba(88,166,255,' + opacity + ')">' + kind + ' <span class="count">' + count + '</span></div>';
    }).join('');
  } catch {}
}
setInterval(refreshCoverage, 3000);
refreshCoverage();

// ---- Failures ----
async function refreshFailures() {
  try {
    const data = await (await fetch('/api/failures')).json();
    const tbody = $('failureTable');
    const none = $('noFailures');
    if (data.length === 0) { none.style.display = ''; return; }
    none.style.display = 'none';
    tbody.innerHTML = data.map(f =>
      '<tr onclick="showFailure(&quot;' + f.id + '&quot;)" style="cursor:pointer">'
      + '<td><a href="#">' + f.id + '</a></td>'
      + '<td>' + f.phase + '</td>'
      + '<td>' + f.seed + '</td>'
      + '<td>' + (f.typesInvolved || []).join(', ') + '</td>'
      + '<td>' + new Date(f.timestamp).toLocaleTimeString() + '</td>'
      + '</tr>'
    ).join('');
  } catch {}
}
setInterval(refreshFailures, 5000);
refreshFailures();

// ---- Failure Detail Modal ----
let currentFiles = {};

async function showFailure(id) {
  try {
    const data = await (await fetch('/api/failures/' + id)).json();
    currentFiles = data.files || {};
    $('modalTitle').textContent = data.id + ' — ' + data.phase + ' (seed ' + data.seed + ')';

    const tabs = $('modalTabs');
    const fileNames = Object.keys(currentFiles);
    tabs.innerHTML = fileNames.map((name, i) =>
      '<div class="tab' + (i === 0 ? ' active' : '') + '" onclick="showTab(&quot;' + name + '&quot;, this)">' + name + '</div>'
    ).join('');

    if (fileNames.length > 0) showTab(fileNames[0]);
    $('modal').classList.add('visible');
  } catch {}
}

const ansi = new AnsiUp();
ansi.use_classes = false;

function showTab(name, tabEl) {
  const pre = $('modalContent');
  const raw = currentFiles[name] || '';
  if (name === 'error.txt') {
    pre.innerHTML = ansi.ansi_to_html(raw);
  } else {
    pre.textContent = raw;
  }
  if (tabEl) {
    document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
    tabEl.classList.add('active');
  }
}

function closeModal() { $('modal').classList.remove('visible'); }
document.addEventListener('keydown', (e) => { if (e.key === 'Escape') closeModal(); });
$('modal').addEventListener('click', (e) => { if (e.target === $('modal')) closeModal(); });

// Expose handlers for inline onclick attributes (required in module scripts)
window.pause = pause;
window.resume = resume;
window.showFailure = showFailure;
window.showTab = showTab;
window.closeModal = closeModal;

// Initial load
fetch('/api/status').then(r => r.json()).then(updateStatus).catch(() => {});
fetch('/api/recent').then(r => r.json()).then(entries => entries.forEach(addLogEntry)).catch(() => {});
</script>
</body>
</html>`;
}
