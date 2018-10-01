'use strict';

import React from 'react';
import ReactDom from 'react-dom';
import { getClientTimestampOffset} from "../tracing";

class TodoApp extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      newTodoText: '',
      todos: [],
    };
    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  componentDidMount() {
    getClientTimestampOffset(offset => this.setState({clientTimestampOffset: offset}));
    this.index();
  }

  index() {
    fetch('/todos.json')
      .then(response => response.json())
      .then(json => this.setState({todos: json}));
  }

  handleChange(event) {
    this.setState({newTodoText: event.target.value});
  }

  handleSubmit(event) {
    fetch('/todos.json', {
      method: 'post',
      headers: {"Content-Type": "application/json"},
      body: JSON.stringify({
        utf8: '✓',
        todo: {
          text: this.state.newTodoText,
        }
      })
    })
      .then(response => response.json())
      .then(json => {
        this.setState(state => ({
            newTodoText: '',
            todos: [...state.todos, json],
          })
        );
      });
    event.preventDefault();
  }

  render() {
    return (
      <div>
        <h1>Todos</h1>
        <p>Client Timestamp Offset: {this.state.clientTimestampOffset}</p>

        <form onSubmit={this.handleSubmit}>
          <div className="field">
            <label htmlFor="todo_text">Text</label>
            <input type="text" value={this.state.newTodoText} onChange={this.handleChange}/>
          </div>

          <div className="actions">
            <input type="submit" value="Create Todo"/>
          </div>
        </form>

        <table>
          <thead>
          <tr>
            <th>Text</th>
          </tr>
          </thead>

          <tbody>
          {
            this.state.todos.map((todo) => {
              return (
                <tr key={todo.key}>
                  <td>{todo.text}</td>
                </tr>
              )
            })
          }
          </tbody>
        </table>
      </div>
    );
  }
}


ReactDom.render(
  <TodoApp/>,
  document.getElementById('todoapp')
);
