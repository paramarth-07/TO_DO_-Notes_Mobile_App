import React, { useState } from 'react';

/**
 * Individual task item component with circular check toggle,
 * priority badge, inline title editing, and deletion.
 */
export default function TodoItem({ todo, onToggle, onUpdate, onDelete }) {
  const [isEditing, setIsEditing] = useState(false);
  const [editTitle, setEditTitle] = useState(todo.title);
  const [editPriority, setEditPriority] = useState(todo.priority);

  const handleSaveEdit = (e) => {
    e.preventDefault();
    if (!editTitle.trim()) return;
    onUpdate(todo.id, {
      title: editTitle.trim(),
      priority: editPriority,
      completed: todo.completed
    });
    setIsEditing(false);
  };

  const handleCancelEdit = () => {
    setEditTitle(todo.title);
    setEditPriority(todo.priority);
    setIsEditing(false);
  };

  // Format date helper
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
    <div className={`todo-card ${todo.completed ? 'todo-completed' : ''}`}>
      {/* Circular Tactile Checkbox */}
      <button
        type="button"
        className={`todo-checkbox ${todo.completed ? 'todo-checkbox-checked' : ''}`}
        onClick={() => onToggle(todo)}
        aria-label={todo.completed ? 'Mark as incomplete' : 'Mark as completed'}
      >
        {todo.completed && (
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3.5" strokeLinecap="round" strokeLinejoin="round">
            <polyline points="20 6 9 17 4 12" />
          </svg>
        )}
      </button>

      {/* Main Content Area or Inline Edit Form */}
      <div className="todo-content">
        {isEditing ? (
          <form className="todo-edit-form" onSubmit={handleSaveEdit}>
            <input
              type="text"
              className="todo-edit-input"
              value={editTitle}
              onChange={(e) => setEditTitle(e.target.value)}
              autoFocus
            />
            <div className="todo-edit-controls">
              <select
                className="priority-select-sm"
                value={editPriority}
                onChange={(e) => setEditPriority(e.target.value)}
              >
                <option value="HIGH">High Priority</option>
                <option value="MEDIUM">Medium Priority</option>
                <option value="LOW">Low Priority</option>
              </select>
              <button type="submit" className="btn-sm btn-primary">Save</button>
              <button type="button" className="btn-sm btn-secondary" onClick={handleCancelEdit}>Cancel</button>
            </div>
          </form>
        ) : (
          <>
            <div className="todo-title-row">
              <span className="todo-title" onClick={() => onToggle(todo)}>
                {todo.title}
              </span>
              <span className={`priority-badge priority-${todo.priority.toLowerCase()}`}>
                {todo.priority}
              </span>
            </div>
            {todo.createdAt && (
              <span className="todo-timestamp">
                Added {formatDate(todo.createdAt)}
              </span>
            )}
          </>
        )}
      </div>

      {/* Action Buttons */}
      {!isEditing && (
        <div className="todo-actions">
          <button
            type="button"
            className="action-btn"
            onClick={() => setIsEditing(true)}
            title="Edit task"
            aria-label="Edit task"
          >
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7" />
              <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z" />
            </svg>
          </button>

          <button
            type="button"
            className="action-btn action-btn-delete"
            onClick={() => onDelete(todo.id)}
            title="Delete task"
            aria-label="Delete task"
          >
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <polyline points="3 6 5 6 21 6" />
              <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
            </svg>
          </button>
        </div>
      )}
    </div>
  );
}
