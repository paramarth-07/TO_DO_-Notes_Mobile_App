import React from 'react';

/**
 * Top Navigation Bar with active tab navigation, live backend status,
 * and quick link to H2 in-memory database console.
 */
export default function Navbar({ activeTab, setActiveTab, backendOnline, onRetryHealth, todoStats, noteStats }) {
  return (
    <header className="navbar">
      <div className="navbar-container">
        {/* Brand Logo & Meta */}
        <div className="navbar-brand">
          <div className="brand-icon">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
              <path d="M12 20h9" />
              <path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z" />
            </svg>
          </div>
          <div>
            <div className="brand-title-wrap">
              <h1 className="brand-title">TaskFlow</h1>
              <span className="brand-tag">Spring Boot + React</span>
            </div>
            <p className="brand-subtitle">Warm Minimal Productivity Suite</p>
          </div>
        </div>

        {/* Navigation Tabs */}
        <nav className="nav-tabs" aria-label="Main Navigation">
          <button
            className={`nav-tab ${activeTab === 'todos' ? 'nav-tab-active' : ''}`}
            onClick={() => setActiveTab('todos')}
          >
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <polyline points="9 11 12 14 22 4" />
              <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11" />
            </svg>
            <span>Tasks</span>
            <span className="tab-badge">{todoStats.pending}</span>
          </button>

          <button
            className={`nav-tab ${activeTab === 'notes' ? 'nav-tab-active' : ''}`}
            onClick={() => setActiveTab('notes')}
          >
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
              <polyline points="14 2 14 8 20 8" />
              <line x1="16" y1="13" x2="8" y2="13" />
              <line x1="16" y1="17" x2="8" y2="17" />
              <polyline points="10 9 9 9 8 9" />
            </svg>
            <span>Notes</span>
            <span className="tab-badge">{noteStats.total}</span>
          </button>

          <button
            className={`nav-tab ${activeTab === 'overview' ? 'nav-tab-active' : ''}`}
            onClick={() => setActiveTab('overview')}
          >
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <rect x="3" y="3" width="7" height="9" />
              <rect x="14" y="3" width="7" height="5" />
              <rect x="14" y="12" width="7" height="9" />
              <rect x="3" y="16" width="7" height="5" />
            </svg>
            <span>Overview</span>
          </button>
        </nav>

        {/* Status Indicators & External Tools */}
        <div className="navbar-actions">
          {/* Backend Health Badge */}
          <div
            className={`health-badge ${backendOnline ? 'health-online' : 'health-offline'}`}
            title={backendOnline ? 'Spring Boot connected at http://localhost:8080' : 'Cannot reach Spring Boot server. Click to retry.'}
            onClick={onRetryHealth}
          >
            <span className="health-dot"></span>
            <span className="health-label">
              {backendOnline ? 'API Connected' : 'API Offline'}
            </span>
          </div>

          {/* Direct link to H2 Web Console */}
          <a
            href="http://localhost:8080/h2-console"
            target="_blank"
            rel="noopener noreferrer"
            className="btn-h2-console"
            title="Open H2 Database in-memory console"
          >
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <ellipse cx="12" cy="5" rx="9" ry="3" />
              <path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3" />
              <path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5" />
            </svg>
            <span>H2 Console</span>
          </a>
        </div>
      </div>
    </header>
  );
}
