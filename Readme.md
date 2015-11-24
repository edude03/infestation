Will write about this when it's not 1am and my eyes don't hurt but basically

```
vagrant up
vagrant ssh	
make install
```
	
Wait awhile

```
exit
vagrant ssh
cd ~/dotfiles
stow zsh
exit
vagrant ssh
```

You'll now have an environment with my favorite tools and their related config files (right now just zsh)

TODOs:

- Autoconfigure antibody based on arch
- source nix vars without bash
- automatically run stow after install
- automatically source the new env after install
- write a proper readme / blog post