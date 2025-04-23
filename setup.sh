#! /bin/sh

TMP_DIR=$(mktemp -d)
echo "tmp dir: ${TMP_DIR}"

echo 'export PATH=${PATH}:${HOME}/.local/bin' >> ~/.zshrc

# download + install nerd font
wget -O "${TMP_DIR}/font.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/Meslo.zip"
unzip "${TMP_DIR}/font.zip" -d "${TMP_DIR}"
sudo mv "${TMP_DIR}"/*.ttf /usr/local/share/fonts/
fc-cache -f -v

# install + configure zsh
sudo apt install -y zsh zsh-syntax-highlighting zsh-autosuggestions fonts-powerline
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

echo "source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
echo "source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
echo "source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

# install eza
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza
echo "alias ls=\"eza --icons=always\"" >> ~/.zshrc

# install zoxide / fzf
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
echo 'eval "$(zoxide init bash)"' >> ~/.zshrc
sudo apt install fzf
echo 'alias cd="z"' >> ~/.zshrc

# TODO: install yazi
#  https://github.com/sxyazi/yazi/releases

# lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo "${TMP_DIR}/lazygit.tar.gz" "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf "${TMP_DIR}/lazygit.tar.gz" lazygit
sudo install lazygit -D -t /usr/local/bin/

# neovim
echo 'export PATH=${PATH}:/opt/nvim-linux-x86_64/bin' >> ~/.zshrc
(
cd "${TMP_DIR}"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
)
# neovim config
git clone git@github.com:zadigus/neovim-wsl.git ~/.config/nvim
# neovim plugin dependencies
sudo apt install nodejs python3 python3-pip python3-venv python-is-python3
pip install ruff black flake8 --break-system-packages

# clean up tmp dir
rm -rf "${TMP_DIR}"
