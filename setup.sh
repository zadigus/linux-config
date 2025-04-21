#! /bin/sh

TMP_DIR=$(mktemp -d)
echo "tmp dir: ${TMP_DIR}"

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

# clean up tmp dir
rm -rf "${TMP_DIR}"
