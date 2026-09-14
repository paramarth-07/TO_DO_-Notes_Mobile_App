import React, { useState } from 'react';
import TodoItem from './TodoItem';

/**
 * TodoList component managing tasks, filter chips ("All", "Pending", "Completed"),
 * priority-based creation input, search query, and summary counters.
 */
export default function TodoList({
  todos,
  filter,
  setFilter,
  searchQuery,
  setSearchQuery,
  onAddTodo,
  onToggleTodo,
  onUpdateTodo,
  onDeleteTodo,
  isLoading
}) {
  const [newTitle, setNewTitle] = useState('');
  const [newPriority, setNewPriority] = useState('MEDIUM');

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!newTitle.trim()) return;
    onAddTodo({
      title: newTitle.trim(),
      priority: newPriority,
      completed: false
    });
    setNewTitle('');
    setNewPriority('MEDIUM');
  };

  // Filter calculations
  const totalCount = todos.length;
  const pendingCount = todos.filter(t => !t.completed).length;
  const completedCount = todos.filter(t => t.completed).length;
  const highPriorityCount = todos.filter(t => t.priority === 'HIGH' && !t.completed).length;

  // Filtered todos based on active tab and search query
  const displayedTodos = todos.filter(todo => {
    const matchesFilter =
      filter === 'all' ? true :
      filter === 'pending' ? !todo.completed :
      todo.completed;

    const matchesSearch = todo.title.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesFilter && matchesSearch;
  });

  return (
    <div className="section-container">
      {/* Top Productivity Metrics Strip */}
      <div className="stats-strip">
        <div className="stat-card">
          <span className="stat-label">Pending Tasks</span>
          <div className="stat-value-group">
            <span className="stat-value">{pendingCount}</span>
            <span className="stat-subtext">of {totalCount} total</span>
          </div>
        </div>

        <div className="stat-card">
          <span className="stat-label">Completed</span>
          <div className="stat-value-group">
            <span className="stat-value stat-value-accent">{completedCount}</span>
            <span className="stat-subtext">tasks finished</span>
          </div>
        </div>

        <div className="stat-card">
          <span className="stat-label">High Priority</span>
          <div className="stat-value-group">
            <span className="stat-value stat-value-urgent">{highPriorityCount}</span>
            <span className="stat-subtext">urgent items</span>
          </div>
        </div>
      </div>

      {/* Inline Task Creation Card */}
      <div className="creation-card">
        <form className="creation-form" onSubmit={handleSubmit}>
          <div className="creation-input-wrap">
            <svg className="creation-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <circle cx="12" cy="12" r="10" />
              <line x1="12" y1="8" x2="12" y2="16" />
              <line x1="8" y1="12" x2="16" y2="12" />
            </svg>
            <input
              type="text"
              className="creation-input"
              placeholder="What needs to be accomplished next?..."
              value={newTitle}
              onChange={(e) => setNewTitle(e.target.value)}
            />
          </div>

          <div className="creation-actions">
            <select
              className="priority-select"
              value={newPriority}
              onChange={(e) => setNewPriority(e.target.value)}
              aria-label="Task Priority"
            >
              <option value="HIGH">High Priority</option>
              <option value="MEDIUM">Medium Priority</option>
              <option value="LOW">Low Priority</option>
            </select>

            <button type="submit" className="btn-primary" disabled={!newTitle.trim()}>
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                <line x1="12" y1="5" x2="12" y2="19" />
                <line x1="5" y1="12" x2="19" y2="12" />
              </svg>
              <span>Add Task</span>
            </button>
          </div>
        </form>
      </div>

      {/* Filter Chips & Search Bar */}
      <div className="controls-bar">
        <div className="filter-chips" role="tablist">
          <button
            className={`filter-chip ${filter === 'all' ? 'filter-chip-active' : ''}`}
            onClick={() => setFilter('all')}
          >
            All
            <span className="chip-counter">{totalCount}</span>
          </button>
          <button
            className={`filter-chip ${filter === 'pending' ? 'filter-chip-active' : ''}`}
            onClick={() => setFilter('pending')}
          >
            Pending
            <span className="chip-counter">{pendingCount}</span>
          </button>
          <button
            className={`filter-chip ${filter === 'completed' ? 'filter-chip-active' : ''}`}
            onClick={() => setFilter('completed')}
          >
            Completed
            <span className="chip-counter">{completedCount}</span>
          </button>
        </div>

        {/* Real-time Search Input */}
        <div className="search-wrap">
          <svg className="search-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
            <circle cx="11" cy="11" r="8" />
            <line x1="21" y1="21" x2="16.65" y2="16.65" />
          </svg>
          <input
            type="text"
            className="search-input"
            placeholder="Filter tasks..."
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
      </div>

      {/* Task Items List */}
      <div className="todo-list">
        {isLoading ? (
          <div className="loading-state">
            <div className="spinner"></div>
            <p>Loading tasks from Spring Boot...</p>
          </div>
        ) : displayedTodos.length > 0 ? (
          displayedTodos.map((todo) => (
            <TodoItem
              key={todo.id}
              todo={todo}
              onToggle={onToggleTodo}
              onUpdate={onUpdateTodo}
              onDelete={onDeleteTodo}
            />
          ))
        ) : (
          <div className="empty-state">
            <div className="empty-icon">
              <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round">
                <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
                <polyline points="22 4 12 14.01 9 11.01" />
              </svg>
            </div>
            <h3 className="empty-title">
              {searchQuery
                ? 'No matching tasks found'
                : filter === 'completed'
                ? 'No completed tasks yet'
                : 'All caught up!'}
            </h3>
            <p className="empty-desc">
              {searchQuery
                ? `No tasks matched "${searchQuery}". Try a different keyword.`
                : 'Create a new task above to keep your productivity flowing.'}
            </p>
          </div>
        )}
      </div>
    </div>
  );
}
