import React, { useState, useEffect, useCallback } from 'react';
import { api } from './services/api';
import Navbar from './components/Navbar';
import TodoList from './components/TodoList';
import NotesGrid from './components/NotesGrid';
import OverviewTab from './components/OverviewTab';
import NoteEditorModal from './components/NoteEditorModal';
import Toast from './components/Toast';
import './App.css';

/**
 * Main Application Component: Orchestrates state, API synchronization,
 * and responsive tab routing across Tasks, Notes, and Overview.
 */
export default function App() {
  // Navigation State
  const [activeTab, setActiveTab] = useState('todos'); // 'todos' | 'notes' | 'overview'

  // Data State
  const [todos, setTodos] = useState([]);
  const [notes, setNotes] = useState([]);

  // Filter & Search State
  const [todoFilter, setTodoFilter] = useState('all'); // 'all' | 'pending' | 'completed'
  const [todoSearch, setTodoSearch] = useState('');

  // Status & UI State
  const [backendOnline, setBackendOnline] = useState(true);
  const [isLoadingTodos, setIsLoadingTodos] = useState(true);
  const [isLoadingNotes, setIsLoadingNotes] = useState(true);
  const [toast, setToast] = useState(null);

  // Modal State
  const [isNoteModalOpen, setIsNoteModalOpen] = useState(false);
  const [editingNote, setEditingNote] = useState(null);

  const showToast = (message, type = 'success') => {
    setToast({ message, type });
  };

  // Check Backend Health
  const checkHealth = useCallback(async () => {
    const online = await api.checkHealth();
    setBackendOnline(online);
    return online;
  }, []);

  // Fetch Todos from Spring Boot REST API
  const fetchTodos = useCallback(async () => {
    setIsLoadingTodos(true);
    try {
      const data = await api.getTodos(todoFilter);
      setTodos(data);
      setBackendOnline(true);
    } catch (err) {
      console.error('Failed to fetch todos:', err);
      setBackendOnline(false);
      showToast('Cannot connect to Spring Boot backend (Port 8080)', 'error');
    } finally {
      setIsLoadingTodos(false);
    }
  }, [todoFilter]);

  // Fetch Notes from Spring Boot REST API
  const fetchNotes = useCallback(async () => {
    setIsLoadingNotes(true);
    try {
      const data = await api.getNotes();
      setNotes(data);
      setBackendOnline(true);
    } catch (err) {
      console.error('Failed to fetch notes:', err);
      setBackendOnline(false);
    } finally {
      setIsLoadingNotes(false);
    }
  }, []);

  // Initial Data Load
  useEffect(() => {
    checkHealth();
    fetchTodos();
    fetchNotes();
  }, [fetchTodos, fetchNotes, checkHealth]);

  // Periodic health check every 15 seconds
  useEffect(() => {
    const interval = setInterval(() => {
      checkHealth();
    }, 15000);
    return () => clearInterval(interval);
  }, [checkHealth]);

  // ==========================================
  // TODO CRUD HANDLERS
  // ==========================================
  const handleAddTodo = async (todoPayload) => {
    try {
      const created = await api.createTodo(todoPayload);
      setTodos(prev => [created, ...prev]);
      showToast(`Task "${created.title}" added`);
    } catch (err) {
      showToast(`Failed to add task: ${err.message}`, 'error');
    }
  };

  const handleToggleTodo = async (todo) => {
    try {
      const updatedPayload = {
        title: todo.title,
        priority: todo.priority,
        completed: !todo.completed
      };
      const result = await api.updateTodo(todo.id, updatedPayload);
      setTodos(prev => prev.map(t => (t.id === result.id ? result : t)));
      showToast(result.completed ? 'Task completed!' : 'Task marked pending');
    } catch (err) {
      showToast(`Failed to update task: ${err.message}`, 'error');
    }
  };

  const handleUpdateTodo = async (id, updatedFields) => {
    try {
      const result = await api.updateTodo(id, updatedFields);
      setTodos(prev => prev.map(t => (t.id === id ? result : t)));
      showToast('Task updated successfully');
    } catch (err) {
      showToast(`Failed to update task: ${err.message}`, 'error');
    }
  };

  const handleDeleteTodo = async (id) => {
    try {
      await api.deleteTodo(id);
      setTodos(prev => prev.filter(t => t.id !== id));
      showToast('Task deleted');
    } catch (err) {
      showToast(`Failed to delete task: ${err.message}`, 'error');
    }
  };

  // ==========================================
  // NOTE CRUD HANDLERS
  // ==========================================
  const handleOpenCreateNote = () => {
    setEditingNote(null);
    setIsNoteModalOpen(true);
  };

  const handleOpenEditNote = (note) => {
    setEditingNote(note);
    setIsNoteModalOpen(true);
  };

  const handleSaveNote = async (noteData) => {
    try {
      if (noteData.id) {
        // Update existing note
        const updated = await api.updateNote(noteData.id, noteData);
        setNotes(prev => {
          const list = prev.map(n => (n.id === updated.id ? updated : n));
          // Re-sort: pinned first, then updatedAt desc
          return list.sort((a, b) => (b.pinned ? 1 : 0) - (a.pinned ? 1 : 0));
        });
        showToast('Note updated successfully');
      } else {
        // Create new note
        const created = await api.createNote(noteData);
        setNotes(prev => {
          const list = [created, ...prev];
          return list.sort((a, b) => (b.pinned ? 1 : 0) - (a.pinned ? 1 : 0));
        });
        showToast('New note created');
      }
      setIsNoteModalOpen(false);
      setEditingNote(null);
    } catch (err) {
      showToast(`Failed to save note: ${err.message}`, 'error');
    }
  };

  const handleTogglePinNote = async (note) => {
    try {
      const updated = await api.updateNote(note.id, {
        title: note.title,
        content: note.content,
        pinned: !note.pinned
      });
      setNotes(prev => {
        const list = prev.map(n => (n.id === updated.id ? updated : n));
        return list.sort((a, b) => (b.pinned ? 1 : 0) - (a.pinned ? 1 : 0));
      });
      showToast(updated.pinned ? 'Note pinned to top' : 'Note unpinned');
    } catch (err) {
      showToast(`Failed to toggle pin: ${err.message}`, 'error');
    }
  };

  const handleDeleteNote = async (id) => {
    try {
      await api.deleteNote(id);
      setNotes(prev => prev.filter(n => n.id !== id));
      showToast('Note deleted');
    } catch (err) {
      showToast(`Failed to delete note: ${err.message}`, 'error');
    }
  };

  // Quick Stats
  const todoStats = {
    total: todos.length,
    pending: todos.filter(t => !t.completed).length,
    completed: todos.filter(t => t.completed).length
  };

  const noteStats = {
    total: notes.length,
    pinned: notes.filter(n => n.pinned).length
  };

  return (
    <div className="app-container">
      {/* Top Navigation */}
      <Navbar
        activeTab={activeTab}
        setActiveTab={setActiveTab}
        backendOnline={backendOnline}
        onRetryHealth={() => {
          checkHealth();
          fetchTodos();
          fetchNotes();
        }}
        todoStats={todoStats}
        noteStats={noteStats}
      />

      {/* Main Content Area */}
      <main className="main-content">
        {activeTab === 'todos' && (
          <TodoList
            todos={todos}
            filter={todoFilter}
            setFilter={setTodoFilter}
            searchQuery={todoSearch}
            setSearchQuery={setTodoSearch}
            onAddTodo={handleAddTodo}
            onToggleTodo={handleToggleTodo}
            onUpdateTodo={handleUpdateTodo}
            onDeleteTodo={handleDeleteTodo}
            isLoading={isLoadingTodos}
          />
        )}

        {activeTab === 'notes' && (
          <NotesGrid
            notes={notes}
            onOpenCreateModal={handleOpenCreateNote}
            onOpenEditModal={handleOpenEditNote}
            onTogglePin={handleTogglePinNote}
            onDeleteNote={handleDeleteNote}
            isLoading={isLoadingNotes}
          />
        )}

        {activeTab === 'overview' && (
          <OverviewTab
            todos={todos}
            notes={notes}
            setActiveTab={setActiveTab}
            onToggleTodo={handleToggleTodo}
            onOpenCreateNote={handleOpenCreateNote}
          />
        )}
      </main>

      {/* Note Editor Modal */}
      <NoteEditorModal
        isOpen={isNoteModalOpen}
        note={editingNote}
        onSave={handleSaveNote}
        onClose={() => {
          setIsNoteModalOpen(false);
          setEditingNote(null);
        }}
      />

      {/* Toast Notification */}
      <Toast toast={toast} onClose={() => setToast(null)} />
    </div>
  );
}
