function! s:handle_bufdir_command(commands)
   "See h: filename-modifiers
   let directory_of_buffer = expand("%:p")
   if directory_of_buffer == ""
      let directory_of_buffer = getcwd()
   endif
   if (!isdirectory(directory_of_buffer))
      "Then it's a full filepath. Drop the filename to get the directory.
      let directory_of_buffer = expand("%:p:h")
   endif

   let original_directory = getcwd()
   execute "cd" directory_of_buffer
   execute a:commands
   execute "cd" original_directory
endfunction

command -nargs=+ Bufdir call <SID>handle_bufdir_command(<q-args>)

