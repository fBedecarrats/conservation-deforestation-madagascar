#!/bin/sh

export QUARTO_VERSION="1.2.174"
sudo curl -o quarto-linux-amd64.deb -L https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb
sudo gdebi quarto-linux-amd64.deb -n




# Create variables
WORK_DIR=/home/onyxia/work/conservation-deforestation-madagascar
REPO_URL=https://${GIT_PERSONAL_ACCESS_TOKEN}@github.com/fBedecarrats/conservation-deforestation-madagascar.git # As initial

# Git
git clone $REPO_URL $WORK_DIR
chown -R onyxia:users $WORK_DIR

# copy files from S3 
mc cp -r s3/fbedecarrats/diffusion/deforestation_madagascar/data $WORK_DIR
mc cp -r s3/fbedecarrats/diffusion/mapme_biodiversity ${WORK_DIR}/data

# Again to give ritghs also in the data subfolder 
chown -R onyxia:users $WORK_DIR

# launch RStudio in the right project
# Copied from InseeLab UtilitR
    echo \
    "
    setHook('rstudio.sessionInit', function(newSession) {
        if (newSession && !identical(getwd(), \"'$WORK_DIR'\"))
        {
            message('On charge directement le bon projet :-) ')
            rstudioapi::openProject('$WORK_DIR')
            # For a slick dark theme
            rstudioapi::applyTheme('Merbivore')
            # Console where it should be
            rstudioapi::executeCommand('layoutConsoleOnRight')
            # To free the CTRL+Y shortcut for 'redo'
            }
            }, action = 'append')
            " >> /home/onyxia/work/.Rprofile
