import React, { useState } from 'react';
import './App.css'

function TextToSoundConverter() {
  const [text, setText] = useState('');
  const [audioUrl, setAudioUrl] = useState('');

  const handleConvert = async () => {
    try {
      const response = await fetch('https://www.buildwithaws.com/test/TextToSpeechConverter?text=' + encodeURIComponent(text));

      if (!response.ok) {
        throw new Error('Failed to convert text to sound');
      }

      const audioData = await response.blob();
      const audioObjectURL = URL.createObjectURL(audioData);
      setAudioUrl(audioObjectURL);
    } catch (error) {
      console.error('Error converting text to sound:', error);
    }
  };

  const handleChangeText = (e) => {
    setText(e.target.value);
    // Reset audio URL when text changes
    setAudioUrl('');
  };

  return (
    <div className="body-content">
      <div className="header">
        <h1>Text to Speech Converter App</h1>
      </div>
      <div className="text-to-sound-container">
        <div className='textarea-container'>
          <textarea value={text} placeholder='Enter your text to convert into speech' onChange={handleChangeText} />
        </div>
        <button onClick={handleConvert}>Convert</button>
        {audioUrl && (
         <audio controls>
          <source src={audioUrl} type="audio/mpeg" />
          Your browser does not support the audio element.
         </audio>
      )}
      </div>
    </div>
  );
}

export default TextToSoundConverter;
