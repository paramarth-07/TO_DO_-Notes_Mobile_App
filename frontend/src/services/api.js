/**
 * API Service for communicating with Spring Boot REST Backend.
 * Targets http://localhost:8080/api/v1
 */

const API_BASE_URL = 'http://localhost:8080/api/v1';

// Helper to handle fetch responses and throw informative errors
async function handleResponse(response) {
  if (!response.ok) {
    let errorMessage = `HTTP ${response.status}: ${response.statusText}`;
    try {
      const errorData = await response.json();
      if (errorData.message) errorMessage = errorData.message;
    } catch {
      // Ignore JSON parse failure on error body
    }
    throw new Error(errorMessage);
  }
  return response.json();
}

export const api = {
  // Probe backend connectivity
  async checkHealth() {
    try {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), 2500);
      const res = await fetch(`${API_BASE_URL}/todos`, { signal: controller.signal });
      clearTimeout(timeoutId);
      return res.ok;
    } catch {
      return false;
    }
  },

  // Todos API
  async getTodos(filter = 'all') {
    let url = `${API_BASE_URL}/todos`;
    if (filter === 'completed') {
      url += '?completed=true';
    } else if (filter === 'pending') {
      url += '?completed=false';
    }
    const response = await fetch(url);
    return handleResponse(response);
  },

  async createTodo(todoData) {
    const response = await fetch(`${API_BASE_URL}/todos`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(todoData),
    });
    return handleResponse(response);
  },

  async updateTodo(id, todoData) {
    const response = await fetch(`${API_BASE_URL}/todos/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(todoData),
    });
    return handleResponse(response);
  },

  async deleteTodo(id) {
    const response = await fetch(`${API_BASE_URL}/todos/${id}`, {
      method: 'DELETE',
    });
    return handleResponse(response);
  },

  // Notes API
  async getNotes() {
    const response = await fetch(`${API_BASE_URL}/notes`);
    return handleResponse(response);
  },

  async createNote(noteData) {
    const response = await fetch(`${API_BASE_URL}/notes`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(noteData),
    });
    return handleResponse(response);
  },

  async updateNote(id, noteData) {
    const response = await fetch(`${API_BASE_URL}/notes/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(noteData),
    });
    return handleResponse(response);
  },

  async deleteNote(id) {
    const response = await fetch(`${API_BASE_URL}/notes/${id}`, {
      method: 'DELETE',
    });
    return handleResponse(response);
  }
};
