import React, { useState, useEffect } from 'react';

/**
 * NoteEditorModal component for creating and editing notes.
 * Includes title, content textarea, pinned toggle switch, and modal keyboard controls.
 */
export default function NoteEditorModal({ isOpen, note, onSave, onClose }) {
  const [title, setTitle] = useState('');
  const [content, setContent] = useState('');
  const [pinned, setPinned] = useState(false);

  useEffect(() => {
    if (note) {
      setTitle(note.title || '');
      setContent(note.content || '');
      setPinned(Boolean(note.pinned));
    } else {
      setTitle('');
      setContent('');
      setPinned(false);
    }
  }, [note, isOpen]);

  // Handle escape key to close modal
  useEffect(() => {
    const handleKeyDown = (e) => {
      if (e.key === 'Escape') onClose();
    };
    if (isOpen) {
      window.addEventListener('keydown', handleKeyDown);
    }
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [isOpen, onClose]);

  if (!isOpen) return null;

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!title.trim()) return;

    onSave({
      id: note?.id,
      title: title.trim(),
      content: content.trim(),
      pinned: pinned
    });
  };

  return (
    <div className="modal-backdrop" onClick={onClose} role="dialog" aria-modal="true">
      <div className="modal-card" onClick={(e) => e.stopPropagation()}>
        {/* Modal Header */}
        <div className="modal-header">
          <div className="modal-title-group">
            <h2 className="modal-title">
              {note ? 'Edit Note' : 'Create New Note'}
            </h2>
            <p className="modal-subtitle">
              {note ? 'Modify your stored note details' : 'Capture ideas, documentation, or meeting snippets'}
            </p>
          </div>
          <button className="modal-close" onClick={onClose} aria-label="Close modal">
            &times;
          </button>
        </div>

        {/* Modal Form */}
        <form onSubmit={handleSubmit} className="modal-form">
          <div className="form-group">
            <label className="form-label" htmlFor="note-title">Note Title</label>
            <input
              id="note-title"
              type="text"
              className="form-input"
              placeholder="e.g., Sprint Planning Notes"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              autoFocus
              required
            />
          </div>

          <div className="form-group">
            <label className="form-label" htmlFor="note-content">Content & Snippets</label>
            <textarea
              id="note-content"
              className="form-textarea"
              placeholder="Write your note content here..."
              rows={6}
              value={content}
              onChange={(e) => setContent(e.target.value)}
            />
          </div>

          {/* Pinned Switch */}
          <div className="form-toggle-row">
            <div className="toggle-info">
              <span className="toggle-label">Pin to Top</span>
              <span className="toggle-desc">Pinned notes appear first in the grid</span>
            </div>
            <label className="switch">
              <input
                type="checkbox"
                checked={pinned}
                onChange={(e) => setPinned(e.target.checked)}
              />
              <span className="slider round"></span>
            </label>
          </div>

          {/* Modal Actions */}
          <div className="modal-actions">
            <button type="button" className="btn-secondary" onClick={onClose}>
              Cancel
            </button>
            <button type="submit" className="btn-primary" disabled={!title.trim()}>
              {note ? 'Update Note' : 'Save Note'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
