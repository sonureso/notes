import sys
from gtts import gTTS
f = open(sys.argv[1], "r")
mytext = f.read()
f.close()
language = 'en-in'
tts = gTTS(text=mytext, lang=language)
tts.save(sys.argv[2])