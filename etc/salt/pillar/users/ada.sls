#
# User pillar for Adam 'hipikat' Wright
########################################

users:
  hipikat:

    # Used by the (SaltStack-blessed) Users formula
    fullname: Ada Wright
    email: ada@hpk.io
    shell: /bin/bash
    sudouser: True
    sudo_rules:
      - 'ALL=(ALL) NOPASSWD: ALL'
    ssh_auth:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKyCuPu+CjJ8z/Xiy8p57JxtbHwCvZe/KPKjkoLauObR9SH1WLwbkgT8nOtYQskuIwcoHERp7GkSjCcI1qGYyILRYPIKmwC2mXyCFtb47PejAS8AhnT9XJ7luPuOL0En7X3las3LfZXjwwBjU1Hr9ZDZMImcki4rUpPcjKhgvsHI/eALO0FcV/4BCYrBKTTl1S8V1nolMb+D4VCpr/a43akqARtr04QKZCQZq/7/q8Dts8f4TaR/YxXEK2n4TZsWdnsxkmGyQwdS0i9qUlyxdXSGLYW9vn+aceOgaYA5RiU/CO2wVm7SCungHjCBgPOQhrbBj6RYWBv3Od1yYsRHad zeno@trepp
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDfu6SFcga+d/flw+/XGGzNIHo7+AKxv1bjg4fJVyUVNee8C8dij2SeLWUFbHroCsIIhsRzstDPdSBIYKTaMC3TKMSEuSfC0QIuZR2jiIMzHWBVEJEFkEFPKofD/sjevwubiCmBI9Ro7upAPKYDRO/tizB5qIV9FxBHOTwcGxQIQqsQJIjabgc6onTlLeCZuj7RtxYdslS+qVxkp4YKGYZFS+poQi7VIvlbf7N6E6PvgRkwaiawZYGH6qXOhaV5edc3Gf1eAzi+rORAgWNIzoiA+u5OX9cz631TqZd9yeBNJdNe3k2FHYB4ZrQXfCeykllXVCAGUkyJUh9Zx5H2XoAj hipikat@mimint
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdN2knnuLR2UgJWXqXeQ6wn01AGbAoTzbf5pholx0qSQnm4CfVc2vDfA8SdlNveNVvq6Z/frymohQPffaqxv/v+LtMxaU3hQRx8znaI+JaLu5VYV6IUwDVPVEddXTx02MlYiW4wzTbq0bT84cAiix5zpvTY2ZNdzboQSTxLjoXqczeDXJ5fmzpEs0lJUBwXxZ6YcbuQ3vxQD8RNxHzgRGGplIrWpiktypgp7yUprXCpV87p2+JhnRrp5iJRD1JuJpgjwgQfmEZJtyM1eI4ln8EIarjhAveNhG4G+Zz32wspC72TcDy0n1Ms/Lp0bKDFm639tLPymQRjkMH3yIypaKx hipikat@bellus
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxQz5QEpMCVOfGrTmrthHyYyx7m9hu8CFV8X5XCm8f9xgTVJ218arRYGSEAsSGQGmgkGySHEeekRzK09m8iwyCob4revOzo1VdJbFvu8sQ0PJ+paWDI1oMNjMSA4z0sIOtnkAYOI4ER8xlja4Bzl92oLsYQF4qGiEzKgnKb2h4JAyKN7OAJfeCePfQoPApxNFF6X9lZ1tI+q8IGYTDJBiwb0DJpG0cii1QQT9Fg23oK+S+wasTniDlXtCbV3PsqcqBEMaf4QLp+22HIXeBcqDVy4N8iaS5w7v7YmwogNWilbXO60ncCXBM/mcCSm4xBOic2i9JIZ2WrAHQTv7l41m5RzujvpI3Yy3D7EOXwrhSSSMr7mApWaT69AIxyxxfTB6xhSqeDVcOpPKexLYWBeRa/26r7TNzxHAzfzJlsJCepaxSTerw4cIIvKnXwBZb/xXSVZ9aNooBKyQP9Whk6u8MAE3LIRfpP3SzlkKcU4BsW8Tvi5tQJEDh13KHBcXhJ1oZNSc0xGctmsWOfQLJgpAFm8eUD1b9sr7vklCXoE15k6KW3xWM70gCkgnKC04/r2zkjhS5WblLcJTV4VsUkmmjVdH93dKxr3YjkLs1M8taL7jTVDjA71oKw2fONOL01Ck8Uam19iRyFQL8xFLN0Gdp5NK1OZew1p6nTjre4tCTjQ== new-mac-2020-01-02

    # Used by the Homeboy formula
    dotfiles:
      url: https://github.com/hipikat/dotfiles.git
      install_cmd: './plumb_files.py --current-user --force'
      #deploy_key: /etc/saltlick/deploy_keys/hipikat-github

    #crontabs:
    #  - '@reboot USER=hipikat SHELL=/bin/bash HOME=/home/hipikat PWD=/home/hipikat sleep 5 && cd /home/hipikat && /home/hipikat/.bin/screen-launch irc-etc'

    uses_system_packages:
      - curl
      - exuberant-ctags
      - git
      - irssi
      - jq
      - mosh
      - screen
      - tree
      - vim
      # For Python package "cryptography"
      - libssl-dev
      - libffi-dev
      # For Python package "lxml"
      - libxml2-dev
      - libxslt1-dev
    uses_python_packages:
     #- fabric
      - flake8
      - httpie
      - pep8
