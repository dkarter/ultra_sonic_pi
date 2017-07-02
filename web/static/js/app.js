// Phoenix' dependencies
import { Socket } from 'phoenix';
import 'phoenix_html';
import moment from 'moment';
import randomColor from 'random-color';

// import React, { Component } from 'react';
// import ReactDOM from 'react-dom';

// class App extends Component {

//   render() {
//     return (
//       <div>REACT COMPONENT</div>
//     );
//   }
// }

// const container = document.getElementById('app-container');
// if (container) {
//   ReactDOM.render(<App />, container);
// }

// -----------------------------
// Code Mirror Setup
// -----------------------------
// TODO: refactor this

const codeContainer = document.getElementById('codeContainer');

const UltraSonicPiClient = {
  cursors: {},
  init(token) {
    this.socket = new Socket('/socket', {
      params: {
        token: token,
      },
    });

    this.editor = CodeMirror.fromTextArea(codeContainer, {
      lineNumbers: true,
      theme: 'dracula',
      tabSize: 2,
      keyMap: 'vim',
      mode: 'text/x-ruby',
      insertSoftTab: true,
    });

    this.messageLog = document.querySelector('#message-log');

    this.socket.connect();

    const songId = codeContainer.getAttribute('data-id');
    const songChan = this.socket.channel(`songs:${songId}`);

    songChan
      .join()
      .receive('ok', resp => console.log('joined!', resp))
      .receive('error', resp => console.log('error join', resp));

    // ====================================================
    //                    Channel Events
    // ====================================================
    songChan.on('text_change', ({ changes, author }) => {
      changes.map(chng => {
        this.editor.replaceRange(chng.text, chng.from, chng.to, 'socket');
      });

      const logItem = document.createElement('li');
      logItem.innerHTML = `${author} is typing...`;
      this.messageLog.appendChild(logItem);

      setTimeout(_ => this.messageLog.removeChild(logItem), 500);
    });

    songChan.on('cursor_change', ({ cursor, author }) => {
      if (this.cursors[author]) {
        this.cursors[author].cursor.remove();
      } else {
        this.cursors[author] = {
          color: randomColor().hexString(),
          cursor: document.createElement('div'),
        };
      }

      const widget = this.cursors[author].cursor;
      widget.className = 'alt-cursor';
      widget.style.backgroundColor = this.cursors[author].color;

      const nameTag = document.createElement('div');
      const nameText = document.createTextNode(author);
      nameTag.className = 'name';
      nameTag.appendChild(nameText);
      widget.appendChild(nameTag);

      const char = cursor.ch;
      const line = cursor.line;
      this.editor.addWidget({ ch: char, line: line }, widget, true);
    });

    // ====================================================
    //                    Editor Events
    // ====================================================
    this.editor.on('changes', function(instance, changes) {
      //TODO: check for each change? not just the first one?
      if (changes[0].origin === 'socket') {
        return true;
      }

      songChan.push('text_change', {
        changes,
      });
    });

    this.editor.on('cursorActivity', codeMirror => {
      const cursor = codeMirror.getCursor();
      songChan.push('cursor_change', {
        cursor,
      });
    });

    const playButton = document.getElementById('playButton');
    playButton.addEventListener('click', () => {
      songChan.push('play', codeContainer.value);
    });
  },
};

if (codeContainer) {
  const token = document
    .querySelector('meta[name="user_token"]')
    .getAttribute('content');

  UltraSonicPiClient.init(token);
}
