import React, { useState } from 'react';

/**
 * NotesGrid component displaying cards in a multi-column responsive layout.
 * Pinned notes appear at the top, followed by recently updated notes.
 */
export default function NotesGrid({
  notes,
  onOpenCreateModal,
  onOpenEditModal,
  onTogglePin,
  onDeleteNote,
  isLoading
}) {
  const [searchQuery, setSearchQuery] = useState('');

  const filteredNotes = notes.filter((note) => {
    const titleMatch = note.title.toLowerCase().includes(searchQuery.toLowerCase());
    const contentMatch = note.content ? note.content.toLowerCase().includes(searchQuery.toLowerCase()) : false;
    return titleMatch || contentMatch;
  });

  const pinnedCount = notes.filter(n => n.pinned).length;

  const formatDate = (isoString) => {
    if (!isoString) return '';
    try {
      const date = new Date(isoString);
      return date.toLocaleDateString(undefined, {
        month: 'short',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      });
    } catch {
      return '';
    }
  };

  return (
    <div className="section-container">
      {/* Header Bar with Action & Search */}
      <div className="notes-header-bar">
        <div className="notes-meta">
          <h2 className="section-heading">Project Notes</h2>
          <span className="section-subheading">
            {notes.length} total notes &bull; {pinnedCount} pinned
          </span>
        </div>

        <div className="notes-actions-wrap">
          {/* Search */}
          <div className="search-wrap">
            <svg className="search-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <circle cx="11" cy="11" r="8" />
              <line x1="21" y1="21" x2="16.65" y2="16.65" />
            </svg>
            <input
              type="text"
              className="search-input"
              placeholder="Search notes..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
            />
            {searchQuery && (
              <button
                type="button"
                className="search-clear"
                onClick={() => setSearchQuery('')}
                aria-label="Clear search"
              >
                &times;
              </button>
            )}
          </div>

          <button className="btn-primary" onClick={onOpenCreateModal}>
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
              <line x1="12" y1="5" x2="12" y2="19" />
              <line x1="5" y1="12" x2="19" y2="12" />
            </svg>
            <span>New Note</span>
          </button>
        </div>
      </div>

      {/* Grid Layout */}
      {isLoading ? (
        <div className="loading-state">
          <div className="spinner"></div>
          <p>Loading notes from Spring Boot...</p>
        </div>
      ) : filteredNotes.length > 0 ? (
        <div className="notes-grid">
          {filteredNotes.map((note) => (
            <div
              key={note.id}
              className={`note-card ${note.pinned ? 'note-card-pinned' : ''}`}
            >
              {/* Note Header */}
              <div className="note-card-header">
                <div className="note-title-wrap">
                  <h3 className="note-title">{note.title}</h3>
                  {note.pinned && (
                    <span className="pinned-badge" title="Pinned to top">
                      <svg width="12" height="12" viewBox="0 0 24 24" fill="currentColor">
                        <path d="M16 12V4h1V2H7v2h1v8l-2 2v2h5.2v6h1.6v-6H18v-2l-2-2z" />
                      </svg>
                      Pinned
                    </span>
                  )}
                </div>

                <button
                  type="button"
                  className={`pin-btn ${note.pinned ? 'pin-btn-active' : ''}`}
                  onClick={() => onTogglePin(note)}
                  title={note.pinned ? 'Unpin note' : 'Pin to top'}
                  aria-label={note.pinned ? 'Unpin note' : 'Pin note'}
                >
                  <svg width="15" height="15" viewBox="0 0 24 24" fill={note.pinned ? 'currentColor' : 'none'} stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                    <path d="M16 12V4h1V2H7v2h1v8l-2 2v2h5.2v6h1.6v-6H18v-2l-2-2z" />
                  </svg>
                </button>
              </div>

              {/* Note Content Snippet */}
              <div className="note-body">
                <p className="note-text">{note.content || <em>No additional content</em>}</p>
              </div>

              {/* Note Footer */}
              <div className="note-card-footer">
                <span className="note-timestamp">
                  {note.updatedAt ? `Updated ${formatDate(note.updatedAt)}` : 'Recently updated'}
                </span>

                <div className="note-actions">
                  <button
                    type="button"
                    className="action-btn"
                    onClick={() => onOpenEditModal(note)}
                    title="Edit note"
                    aria-label="Edit note"
                  >
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                      <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
                      <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
                    </svg>
                  </button>

                  <button
                    type="button"
                    className="action-btn action-btn-delete"
                    onClick={() => onDeleteNote(note.id)}
                    title="Delete note"
                    aria-label="Delete note"
                  >
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                      <polyline points="3 6 5 6 21 6" />
                      <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
                    </svg>
                  </button>
                </div>
              </div>
            </div>
          ))}
        </div>
      ) : (
        <div className="empty-state">
          <div className="empty-icon">
            <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
              <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
              <polyline points="14 2 14 8 20 8" />
              <line x1="12" y1="18" x2="12" y2="12" />
              <line x1="9" y1="15" x2="15" y2="15" />
            </svg>
          </div>
          <h3 className="empty-title">
            {searchQuery ? 'No matching notes found' : 'No notes created yet'}
          </h3>
          <p className="empty-desc">
            {searchQuery
              ? `No notes matched "${searchQuery}".`
              : 'Add meeting summaries, design tokens, or architectural thoughts.'}
          </p>
          <button className="btn-primary" onClick={onOpenCreateModal} style={{ marginTop: '16px' }}>
            Create First Note
          </button>
        </div>
      )}
    </div>
  );
}
