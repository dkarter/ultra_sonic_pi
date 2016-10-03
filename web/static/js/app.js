// Phoenix' dependencies
import { Socket } from 'phoenix';
import 'phoenix_html';

import React, { Component } from 'react';
import ReactDOM from 'react-dom';

class App extends Component {

  render() {
    return (
      <div>REACT COMPONENT</div>
    );
  }
}

const container = document.getElementById('app-container');
if (container) {
  ReactDOM.render(<App />, container);
}

// -----------------------------
// Code Mirror Setup
// -----------------------------
// TODO: refactor this

const codeContainer = document.getElementById("codeContainer");

const UltraSonicPiClient = {
  init() {
    this.socket = new Socket('/socket');

    this.editor = CodeMirror.fromTextArea(codeContainer, {
      lineNumbers: true,
      theme: 'dracula',
      tabSize: 2,
      keyMap: 'vim',
      mode: "text/x-ruby",
      insertSoftTab: true,
    });

    this.socket.connect();

    const songId = codeContainer.getAttribute('data-id');
    const songChan = this.socket.channel(`songs:${songId}`);

    songChan.join()
      .receive('ok', resp => console.log('joined!', resp))
      .receive('error', resp => console.log('error join', resp));

    songChan.on('text_change', ({changes}) => {
      changes.map((chng) => {
        this.editor.replaceRange(chng.text, chng.from, chng.to, 'socket');
      })
    });

    this.editor.on('changes', function(instance, changes){
      //TODO: check for each change? not just the first one?
      if (changes[0].origin === 'socket') {
        return true;
      }

      songChan.push('text_change', { changes });
    });

    const playButton = document.getElementById('playButton');
    playButton.addEventListener('click', () => {
      songChan.push('play', codeContainer.value);
    })
  }
}

if (codeContainer) {
  UltraSonicPiClient.init();
}

    // TODO: add widget to show other people's cursor
    // const widget = document.createElement('div');
    // widget.className = 'alt-cursor';
    // const nameTag = document.createElement('div');
    // const nameText = document.createTextNode('User 1');
    // nameTag.className = 'name';
    // nameTag.appendChild(nameText);
    // widget.appendChild(nameTag);

    // TODO: should not rely on change to insert widget but on socket message received
      // const cursor = editor.getCursor();
      // const char = cursor.ch + 5;
      // const line = cursor.line + 2;
      // window.editor.addWidget({ch: char, line: line}, widget, true);
