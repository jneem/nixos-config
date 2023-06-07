source /home/jneeman/.config/nushell/default_config.nu

let-env PATH = ($env.PATH | prepend "/home/jneeman/.config/carapace/bin")
let-env EDITOR = hx
let-env config = ($env.config | upsert show_banner false)
