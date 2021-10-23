const fs = require("fs");

const allCmds = [
  {
    name: "cdw",
    cmds: [
      {
        cmdTrigger: "cdw ",
        cmdListOptions: "ls -d ~/workspace/*/",
        fzfOptions: "--preview 'tree -C {} | head -200'",
      },
    ],
  },
  {
    name: "cdws",
    cmds: [
      {
        cmdTrigger: "cdws ",
        cmdListOptions: "ls -d ~/ws/*/",
        fzfOptions: "--preview 'tree -C {} | head -200'",
      },
    ],
  },
  {
    name: "brew",
    cmds: [
      {
        cmdTrigger: "brew install --cask ",
        // cmdListOptions: 'brew search --casks',
        cmdListOptions: 'cache_fzf.js "brew install --cask"',
        fzfOptions: "--multi --preview 'brew info --cask {}'",
      },
      {
        cmdTrigger: "brew install ",
        // cmdListOptions: 'brew formulae',
        cmdListOptions: 'cache_fzf.js "brew install"',
        fzfOptions: "--multi --preview 'brew info {}'",
      },
      {
        cmdTrigger: "brew uninstall --cask ",
        cmdListOptions: "brew list --cask",
        fzfOptions: "--multi --preview 'brew info --cask {}'",
      },
      {
        cmdTrigger: "brew uninstall ",
        cmdListOptions: "brew list --formula",
        fzfOptions: "--multi --preview 'brew info {}'",
      },
    ],
  },
  {
    name: "git",
    cmds: [
      {
        cmdTrigger: "git add ",
        cmdListOptions: 'cache_fzf.js "git co"',
        // cmdListOptions: 'git status -s | sed s/^...//',
        fzfOptions: "--multi",
      },
      {
        cmdTrigger: "git co ",
        cmdListOptions: 'cache_fzf.js "git co"',
        // cmdListOptions: 'git status -s | sed s/^...//',
        fzfOptions: "--multi",
      },
      {
        cmdTrigger: "git cob ",
        cmdListOptions:
          "git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short)'",
        fzfOptions: "--multi",
      },
    ],
  },
  {
    name: "yarn",
    cmds: [
      {
        cmdTrigger: "yarn test",
        cmdListOptions: `rg --files --hidden --glob '!.git' -g '*.test.ts*' -g '*.test.js*' -g '*.it.ts*' -g '*.it.js*' 2> /dev/null`,
        fzfOptions: "--multi",
      },
    ],
  },
  {
    name: "pip",
    cmds: [
      {
        cmdTrigger: "pip uninstall",
        cmdListOptions: `pip list 2> /dev/null | tail -n +3 | awk '{print $1}' | rg -v '^(setuptools|wheel)$'`,
        fzfOptions: `--multi --preview 'pip show {}'`,
      },
    ],
  },
  {
    name: "node",
    cmds: [
      {
        cmdTrigger: "node ",
        cmdListOptions: `rg --files --hidden --glob '!.git' -g '*.ts*' -g '*.js*' 2> /dev/null`,
        fzfOptions: "--multi",
      },
    ],
  },
  {
    name: "bloop",
    cmds: [
      {
        cmdTrigger: "bloop test ",
        cmdListOptions: `bloop autocomplete --format zsh --mode projects 2> /dev/null`,
        fzfOptions: "--multi",
      },
      {
        cmdTrigger: "bloop compile ",
        cmdListOptions: `bloop autocomplete --format zsh --mode projects 2> /dev/null`,
        fzfOptions: "--multi",
      },
    ],
  },
  {
    name: "bazel",
    cmds: [
      {
        cmdTrigger: "bloop test ",
        cmdListOptions: `bloop autocomplete --format zsh --mode projects 2> /dev/null`,
        fzfOptions: "--multi",
      },
      {
        cmdTrigger: "bloop build ",
        cmdListOptions: `bloop autocomplete --format zsh --mode projects 2> /dev/null`,
        fzfOptions: "--multi",
      },
    ],
  },
  {
    name: "docker",
    cmds: [
      {
        cmdTrigger: "docker rm ",
        cmdListOptions: `docker ps -a`,
        fzfOptions: "--multi",
        postColumn: "1",
      },
      {
        cmdTrigger: "docker image rm ",
        cmdListOptions: `docker images -a`,
        fzfOptions: "--multi",
        postColumn: "3",
      },
      {
        cmdTrigger: "docker volume rm ",
        cmdListOptions: `docker volume ls`,
        fzfOptions: "--multi",
        postColumn: "2",
      },
    ],
  },
  {
    name: "gulp",
    cmds: [
      {
        cmdTrigger: "gulp ",
        cmdListOptions: "cache_fzf.js 'gulp'",
        // cmdListOptions: "npx gulp --tasks --depth 1 | tail -n +3 | awk '{print $3}' | sort",
        fzfOptions: "--multi",
      },
    ],
  },
];

function generateFunc(name, cmds) {
  return `
_fzf_complete_${name}() {
  ARGS="$@"
  ${cmds
    .map(
      ({ cmdTrigger, cmdListOptions, fzfOptions }) =>
        `if [[ $ARGS == '${cmdTrigger}'* ]]; then
    local options="$(${cmdListOptions})"
    _fzf_complete ${fzfOptions} -- "$@" < <(
      echo $options
    )`
    )
    .join("\n  el")}
  else
    return 1
  fi
}
${generatePostProcessing(name, cmds)}
  `.trim();
}
function generatePostProcessing(name, cmds) {
  cmds = cmds.filter(({ postColumn }) => postColumn);
  if (!cmds.length) {
    return "";
  }
  return `
_fzf_complete_${name}_post() {
  ${cmds
    .map(
      ({ cmdTrigger, postColumn }) =>
        `if [[ $ARGS == '${cmdTrigger}'* ]]; then
    awk '{print $${postColumn}}'`
    )
    .join("\n  el")}
  else
    return 1
  fi
}
  `.trim();
}
const result = allCmds
  .map(({ name, cmds }) => generateFunc(name, cmds))
  .join("\n");
const header = `
## AUTOGENERATED
## fzf examples - completion
# https://github.com/junegunn/fzf/wiki/Examples-(completion)
`.trim();

const fileContents = `${header}\n\n${result}`;
fs.writeFileSync(".zshrc-fzf-completion", fileContents);
