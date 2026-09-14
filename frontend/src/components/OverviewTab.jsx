import React from 'react';

/**
 * OverviewTab: Unified dashboard showcasing productivity stats,
 * urgent high-priority tasks, pinned notes, and presentation architecture notes.
 */
export default function OverviewTab({
  todos,
  notes,
  setActiveTab,
  onToggleTodo,
  onOpenCreateNote
}) {
  const totalTodos = todos.length;
  const completedTodos = todos.filter(t => t.completed).length;
  const pendingTodos = todos.filter(t => !t.completed).length;
  const completionPercentage = totalTodos > 0 ? Math.round((completedTodos / totalTodos) * 100) : 0;

  const urgentTodos = todos.filter(t => !t.completed && t.priority === 'HIGH');
  const pinnedNotes = notes.filter(n => n.pinned);

  return (
    <div className="section-container">
      {/* Welcome Banner */}
      <div className="overview-hero">
        <div className="overview-hero-content">
          <span className="overview-badge">Academic Demonstration Suite</span>
          <h2 className="overview-title">Welcome to TaskFlow Dashboard</h2>
          <p className="overview-subtitle">
            Synchronized with embedded Spring Boot 3 &amp; in-memory H2 database.
            Powering both this React Web client and the Flutter Mobile app.
          </p>
        </div>

        {/* Completion Gauge Card */}
        <div className="progress-card">
          <div className="progress-header">
            <span className="progress-label">Task Completion Rate</span>
            <span className="progress-percent">{completionPercentage}%</span>
          </div>
          <div className="progress-bar-track">
            <div
              className="progress-bar-fill"
              style={{ width: `${completionPercentage}%` }}
            ></div>
          </div>
          <div className="progress-footer">
            <span>{completedTodos} completed</span>
            <span>{pendingTodos} remaining</span>
          </div>
        </div>
      </div>

      {/* Two-Column Overview Split */}
      <div className="overview-grid">
        {/* Left Column: Urgent High-Priority Tasks */}
        <div className="overview-panel">
          <div className="panel-header">
            <div className="panel-title-wrap">
              <h3 className="panel-title">Urgent Tasks</h3>
              <span className="panel-badge-urgent">{urgentTodos.length} high priority</span>
            </div>
            <button className="panel-link" onClick={() => setActiveTab('todos')}>
              View All Tasks &rarr;
            </button>
          </div>

          <div className="panel-list">
            {urgentTodos.length > 0 ? (
              urgentTodos.slice(0, 4).map(todo => (
                <div key={todo.id} className="overview-item">
                  <button
                    className="todo-checkbox"
                    onClick={() => onToggleTodo(todo)}
                    title="Mark completed"
                  ></button>
                  <span className="overview-item-title">{todo.title}</span>
                  <span className="priority-badge priority-high">HIGH</span>
                </div>
              ))
            ) : (
              <div className="panel-empty">
                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <polyline points="20 6 9 17 4 12" />
                </svg>
                <p>No high-priority tasks pending! Great job.</p>
              </div>
            )}
          </div>
        </div>

        {/* Right Column: Pinned Architecture & Meeting Notes */}
        <div className="overview-panel">
          <div className="panel-header">
            <div className="panel-title-wrap">
              <h3 className="panel-title">Pinned Notes</h3>
              <span className="panel-badge-note">{pinnedNotes.length} pinned</span>
            </div>
            <button className="panel-link" onClick={() => setActiveTab('notes')}>
              View All Notes &rarr;
            </button>
          </div>

          <div className="panel-list">
            {pinnedNotes.length > 0 ? (
              pinnedNotes.slice(0, 3).map(note => (
                <div key={note.id} className="overview-note-item">
                  <div className="overview-note-header">
                    <span className="overview-note-title">{note.title}</span>
                    <span className="pinned-badge">Pinned</span>
                  </div>
                  <p className="overview-note-snippet">{note.content}</p>
                </div>
              ))
            ) : (
              <div className="panel-empty">
                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
                  <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
                </svg>
                <p>No pinned notes yet.</p>
                <button className="btn-sm btn-primary" onClick={onOpenCreateNote}>
                  Create Note
                </button>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Bottom Architectural Callout for Viva Evaluators */}
      <div className="architecture-callout">
        <div className="callout-icon">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <polygon points="12 2 2 7 12 12 22 7 12 2" />
            <polyline points="2 17 12 22 22 17" />
            <polyline points="2 12 12 17 22 12" />
          </svg>
        </div>
        <div className="callout-content">
          <h4 className="callout-title">Full-Stack Decoupled Architecture</h4>
          <p className="callout-desc">
            This dashboard uses React <code>useState</code> and <code>useEffect</code> hooks to fetch live JSON from Spring Boot <code>/api/v1/todos</code> and <code>/api/v1/notes</code>.
            Because CORS is enabled via <code>@CrossOrigin</code>, the exact same backend endpoints serve the Flutter mobile application without any server modifications.
          </p>
        </div>
      </div>
    </div>
  );
}
