source /home/jneeman/.config/nushell/default_config.nu

let carapace_completer = {|spans|
    carapace $spans.0 nushell $spans | from json
}

let-env PATH = ($env.PATH | prepend "/home/jneeman/.config/carapace/bin")
let-env EDITOR = hx
let-env config = ($env.config | merge {
  show_banner: false
  completions: {
    case_sensitive: false # set to true to enable case-sensitive completions
    quick: true  # set this to false to prevent auto-selecting completions when only one remains
    partial: true  # set this to false to prevent partial filling of the prompt
    algorithm: "prefix"  # prefix or fuzzy
    external: {
      enable: true # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up my be very slow
      max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
      completer: $carapace_completer
    }
  }
})
