#!/usr/bin/bash

git_info="";

current_path=$(tmux display-message -p '#{pane_current_path}')
cd $current_path

if [ -d .git ]; then
  branch_name=$(git rev-parse --abbrev-ref HEAD)
  git_info="${git_info}#[bold,fg=white]⌥ ${branch_name}#[default]";

  if [ -n "$(git status --porcelain)" ]; then
    diff_stat=$(git diff --stat | tail -n 1 | awk '{print $1 " ⎙", "#[fg=green]+" $4, "#[fg=red]-" $6 "#[default]"}')
    git_info="${git_info} ● ${diff_stat}"
  fi

  behind=$(git rev-list HEAD.."origin/${branch_name}" --count)
  if [ "${behind}" != 0 ]; then
    git_info="${git_info} #[fg=red]↓${behind}#[default]"
  fi

  ahead=$(git rev-list "origin/${branch_name}"..HEAD --count)
  if [ "${ahead}" != 0 ]; then
    git_info="${git_info} #[fg=green]↑${ahead}#[default]"
  fi
else
 git_info="${git_info}-"
fi

echo $git_info
