set rtp+=$PWD
set rtp+=$PLENARY_DIR

runtime plugin/plenary.vim

if $INIT_FILE =~ ".lua$"
  luafile $INIT_FILE
endif

if $INIT_FILE =~ ".vim$"
  source $INIT_FILE
endif

lua require('plenary.busted')

