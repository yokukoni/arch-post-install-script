#!/usr/bin/env bash
#
# install.sh

polkit="/etc/polkit-1/rules.d/90-corectrl.rules"


First() {
    echo "Installing daily necessities..."

    # check for updates first
    sudo pacman -Syu
    sudo pacman -S base-devel htop neofetch git \
               discord telegram-desktop \
               vlc gimp chromium \
               openrazer-daemon corectrl
}
First

Second() {
    echo "Installing other necessities...."

    # fix for spotify gpg key issue
    sudo curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg  | gpg --import - \

    # begin
    yay -S brave-bin \
           freeoffice \
           latte-dock-git \
           spotify
}
Second

Third() {
    echo "Installing game applications and related dependencies...."

    sudo pacman -S --needed lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader \
                   steam
    
    # outside official repo
    yay -S mangohud-git polychromatic \
           an-anime-game-launcher-bin the-honkers-railway-launcher-bin honkers-launcher-bin

}
Third

Fourth() {
    echo "Installing appmenu fixes..."

    sudo pacman -S libdbusmenu-glib libdbusmenu-gtk2 libdbusmenu-gtk3 libdbusmenu-qt5 libdbusmenu-qt6 lib32-libdbusmenu-glib lib32-libdbusmenu-gtk2 lib32-libdbusmenu-gtk3 \
                   appmenu-gtk-module zenity
    yay -S libunity
}
Fourth

Last() {
    echo "Applying another set of fixes"

    # run corectrl on startup
    cp /usr/share/applications/org.corectrl.corectrl.desktop ~/.config/autostart/org.corectrl.CoreCtrl.desktop

    # no more asking for root password for corectrl
    # check if the file exists
    if [-e $polkit]; then
        echo "$polkit already exists"
    else
        echo "polkit.addRule(function(action, subject) {
        if ((action.id == "org.corectrl.helper.init" ||
            action.id == "org.corectrl.helperkiller.init") &&
            subject.local == true &&
            subject.active == true &&
            subject.isInGroup("$USER")) {
                return polkit.Result.YES;
            }
        });" >> $polkit

    # fix for openrazer
    sudo gpasswd -a $USER plugdev
}
Last