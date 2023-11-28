#!/bin/bash

version='1.0.0'
blueBold="\e[1;34m"
yellowBold='\e[1m\e[33m'
redBold='\e[1m\e[31m'
greenBold='\e[32m\e[1m'
exitColor='\e[0m'
flutterSwitchText='\e[1m\e[33m
  ______ _____ __  __ 
 |  ____/ ____|  \/  |
 | |__ | (___ | \  / |
 |  __| \___ \| |\/| |
 | |    ____) | |  | |
 |_|   |_____/|_|  |_|
\e[0m'

# curret fsm version
fsmInformation() {
    developer="Deepak Sapkota"
    # ANSI escape codes for blue and bold text
    echo -e "$flutterSwitchText"
    echo -e "Current Version : \e[1m$version\e[0m"  # Bold version text
    echo -e "Developer : $blue_bold$developer\e[0m"  # Blue and bold developer text
    echo "Repo : https://github.com/sjdpk/fsm"
    echo ""
}


fsmNotes() {
    developer=" Deepak Sapkota"
    echo -e " Current Version : \e[1m$version\e[0m"  # Bold version text
    echo -e " Developer : $blueBold$developer\e[0m"  # Blue and bold developer text
    echo " Repo : https://github.com/sjdpk/fsm"
    echo 
}

# update fsm
updateFSMVersion() {
  echo -e "$flutterSwitchText"
  rm -rf ~/.fsm
  git clone https://github.com/sjdpk/fsm.git ~/.fsm
  echo "update shell eg: [ source ~/.zshrc, source ~/.bashrc, ...]" 
}

# check version
checkFlutterVersion(){
    flutter --version
}

# list locally installed versions of node
locallyInstalledFlutterVersionsList(){
    blue_bold="\e[1;34m"
    flutterDir=$(dirname $(dirname $(dirname $(which flutter))))
    for dir in "$flutterDir"/flutter*/; do
        if [ -d "$dir" ]; then
            cd "$dir" || exit
            flutter_version=$("${dir}bin/flutter" --version | grep -oE "Flutter [0-9]+\.[0-9]+\.[0-9]+")
            echo -e " 👉  $blue_bold$flutter_version\e[0m"
        fi
    done
}

# version switch
flutterSDKVersionSwitch(){
    newFlutterVersion="$1"
    newFlutterName="flutter-$newFlutterVersion"

    currentDir=$(pwd) # store current directory
    
    inUseFlutterVersion=$(flutter --version | grep -oE "[0-9]+\.[0-9]+\.[0-9]+" | head -n 1)

    if [ "$newFlutterVersion" = "$inUseFlutterVersion" ]; then
        echo -e "$redBold You are already using Flutter version $inUseFlutterVersion $exitColor"
    else 
        declare -a availableFlutterVersionsList
        flutterDir=$(dirname $(dirname $(dirname $(which flutter))))
        for dir in "$flutterDir"/flutter*/; do
            if [ -d "$dir" ]; then
                cd "$dir" || exit
                flutter_version=$("${dir}bin/flutter" --version | grep -oE "[0-9]+\.[0-9]+\.[0-9]+" | head -n 1)
                flutterVersions+=("$flutter_version") # Append the version to the array
            fi
        done
        # Check if the array contains a specific version
        if [[ " ${flutterVersions[@]} " =~ " $newFlutterVersion " ]]; then
            cd "$flutterDir"
            sudo mv "flutter" "flutter-$inUseFlutterVersion"
            sudo mv "$newFlutterName" "flutter"
            echo -ne " 👉 $greenBold Switching Progress: $exitColor"
            for ((i=1; i<=10; i++)); do
                echo -e -n "$greenBold=$exitColor"
                sleep 0.1
            done
            echo -e " $greenBold100%$exitColor"
            echo
            echo -e "🎊 🎊$greenBold Switched Flutter from Flutter $inUseFlutterVersion to Flutter $newFlutterVersion $exitColor🎊 🎊"
            echo
        else
            echo -e "$redBold Flutter version $newFlutterVersion is not available\e[0m"
            yellow_bold="\e[1m\e[33m"
            echo -e "$yellowBold Available versions: $exitColor"
            locallyInstalledFlutterVersionsList # list all available versions
        fi
    fi 
    cd "$currentDir"
}

# flutter specific verison download
downloadFlutterVersion(){
    flutterVersionToDownload="$1"
    currentDir=$(pwd) # store current directory
    declare -a availableFlutterVersionsList
    flutterDir=$(dirname $(dirname $(dirname $(which flutter))))
    for dir in "$flutterDir"/flutter*/; do
        if [ -d "$dir" ]; then
            cd "$dir" || exit
            flutter_version=$("${dir}bin/flutter" --version | grep -oE "[0-9]+\.[0-9]+\.[0-9]+" | head -n 1)
            flutterVersions+=("$flutter_version") # Append the version to the array
        fi
    done

    # Check if the array contains a specific version
    if [[ " ${flutterVersions[@]} " =~ " $flutterVersionToDownload " ]]; then
        echo -e "$greenBold Flutter version $flutterVersionToDownload is already in your system$exitColor"
        echo
    else
        # download flutter
        osName=$(uname -s) # get the os name
        if [ "$osName" = "Linux" ]; then
            #    curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_$newVersion-stable.zip
            #    sudo mv "flutter" "$oldName"
            #    unzip flutter_linux_$newVersion-stable.zip
            echo "download for Linux"
            if command -v curl &> /dev/null; then
                cd ~/Downloads   
                curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_$flutterVersionToDownload-stable.tar.xz
                echo -e "🎊 🎊$greenBold Download Complete 🎊 🎊$exitColor"
                echo -e "👨‍🎤👨‍🎤 $greenBold Extraction is in progress ... 🎊 🎊 $exitColor"
                if command -v tar &> /dev/null; then
                    tar -xJf flutter_linux_$flutterVersionToDownload-stable.tar.xz 
                    mv flutter "flutter-$flutterVersionToDownload"
                    echo -e "🧑‍💻🧑‍💻 $yellowBold Setting up new version... 🎊 🎊 $exitColor"
                    rm -r flutter_linux_$flutterVersionToDownload-stable.tar.xz
                    sudo mv "flutter-$flutterVersionToDownload" $flutterDir
                    echo
                    echo -e "$yellowBold fsm use $flutterVersionToDownload $exitCode"
                    echo
                else
                    echo 
                    echo -e "$redBold Error : tar in't installed in you system $exitColor"
                    echo
                fi
            else
                echo 
                echo -e "$redBold Error : curl in't installed in you system $exitColor"
                echo
            fi
        else
            echo "Currently FSM Support Linux Only"
        fi
    fi
    cd "$currentDir"
}

# help function
displayHelp() {
    echo
    fsmNotes
    echo
    echo -e "$yellowBold Useful FSM commands $exitColor"
    echo -e " Usage: fsm [OPTIONS]"
    echo -e "\n Options:"
    echo -e "   -v, --version    Display the version of the flutter"
    echo -e "   ls, --list       List locally installed Flutter versions"
    echo -e "   info             Display information about the current script version"
    echo -e "   update           Update the FSM version"
    echo -e "   use <version>    Switch to a specific Flutter version"
    echo -e "   help             Display this help information"
    echo -e "   create <project-name>   Create a new flutter project"
    echo -e "   feature <feature-name>  Create a new feature folder structure"
    echo -e "\n Examples:"
    echo -e "   fsm -v"
    echo -e "   fsm ls"
    echo -e "   fsm info"
    echo -e "   fsm update"
    echo -e "   fsm use 3.3.3"
    echo -e "   fsm create my_app"
    echo -e "   fsm feature auth"
}

# feature folder creation
createFeatureFoldersStr() {
    local featureName="$1"

    if [ -d "$featureName" ]; then
        echo
        echo -e "$redBold Error: Feature '$featureName' already exists. Please choose a different name. $exitColor"
        echo
        exit 1
    fi

    mkdir -p "$featureName/data/datasource/local"
    touch "$featureName/data/datasource/local/.gitkeep"
    mkdir -p "$featureName/data/datasource/remote"
    touch "$featureName/data/datasource/remote/.gitkeep"
    mkdir -p "$featureName/data/models"
    touch "$featureName/data/models/.gitkeep"
    mkdir -p "$featureName/data/repository"
    touch "$featureName/data/repository/.gitkeep"

    mkdir -p "$featureName/domain/entity"
    touch "$featureName/domain/entity/.gitkeep"
    mkdir -p "$featureName/domain/repository"
    touch "$featureName/domain/repository/.gitkeep"
    mkdir -p "$featureName/domain/usecase"
    touch "$featureName/domain/usecase/.gitkeep"

    mkdir -p "$featureName/presentation/bloc"
    touch "$featureName/presentation/bloc/.gitkeep"
    mkdir -p "$featureName/presentation/screen"
    touch "$featureName/presentation/screen/.gitkeep"
    mkdir -p "$featureName/presentation/widget"
    touch "$featureName/presentation/widget/.gitkeep"
    
    echo
    echo -e "$greenBold 👉 Folder structure created successfully for feature: $featureName 👏 $exitColor"
    echo
}

# create flutter project
appendToFile() {
    local content=$1
    local file_path=$2
    echo "$content" >> "$file_path"
}
createFlutterProject() {
    local applicationName=$1
    echo 
    read -p "Enter the App ID (default:, com.example): " appId
    read -p "Is your app support firebase ? [y/N] : " firebaseStatus
    read -p "Is your app support localdb ? [y/N] : " localDBStatus
    read -p "Is your app support localizations? [y/N] : " localizationsStatus
    read -p "Is your app support Multiple Env (Eg., local,dev,prod)? [y/N] : " envStatus

    if [ -n "$appId" ]; then
        flutter create --org "$appId" "$applicationName"
    else
        flutter create "$applicationName"
    fi

    # Go to the lib folder of the newly created project and create the src folder
    cd $applicationName/lib
    # Create the main project structure
    mkdir -p src/{config/{api,router,themes},core/{extensions,network,resources,services,utils,widgets}}
    mkdir -p src/core/services/validator

    # Create files in the config folder
    touch src/config/api/api_collection.dart
    if [ "$envStatus" = "y" ]; then
        mkdir src/config/env
        touch src/config/env/{base_env.dart,dev_env.dart,env.dart,local_env.dart,prod_env.dart}
    fi

    if [ "$localizationsStatus" = "y" ]; then
        mkdir src/config/localization
        touch src/config/localization/{intl_en.arb,intl_ne.arb,l10n.dart,localization.dart}
    fi
    touch src/config/router/{app_routes.dart,custom_transition.dart}
    touch src/config/themes/app_theme.dart

    # Create files in the core folder
    touch src/core/extensions/{string_extension.dart,widget_extensions.dart}
    touch src/core/network/data_state.dart
    touch src/core/resources/{colors.dart,constants.dart,images.dart}
    if [ "$firebaseStatus" = "y" ]; then
        mkdir src/core/services/firebase
        touch src/core/services/firebase/{firebase_crashlogger.dart,firebase.dart,firebase_notification.dart,firebase_services.dart,local_notification.dart}
    fi
    if [ "$localDBStatus" = "y" ]; then
        mkdir src/core/services/localdb
        touch src/core/services/localdb/{db.dart,db_service.dart,db_utils.dart}
    fi
    touch src/core/services/validator/validator.dart
    touch src/core/utils/{common.dart}
    touch src/core/widgets/{app_dialog.dart,asynctext.dart,backbutton.dart,button.dart,dropdown_search.dart,images.dart,language_switchbtn.dart,loading.dart,marquee.dart,modal_sheet.dart,readmoretext.dart,shimmer_widget.dart,skipbtn.dart,snackbar.dart,text.dart,textformfield.dart,transparent_appbar.dart}
    echo -3 "$greenBold 👉 Flutter project created successfully 👏 $exitColor"
}


opt=$1
case $opt
in
    -v|--version) checkFlutterVersion ;;
    ls|--list) locallyInstalledFlutterVersionsList ;;
    info) fsmInformation ;;
    update) updateFSMVersion ;;
    use) version_to_use=$2
        if [ -n "$version_to_use" ]; then
            flutterSDKVersionSwitch "$version_to_use"
        else
            echo -e "$redBold Please provide a version number after 'use' option.$exitColor"
        fi
        ;;
    install) version_to_install=$2
        if [ -n "$version_to_install" ]; then
            downloadFlutterVersion "$version_to_install"
        else
            echo -e "$redBold Please provide a version number after 'install' option.$exitColor"
        fi
        ;;

    create) applicationName=$2 
        if [ -n "$applicationName" ]; then
            createFlutterProject "$applicationName"
        else
            echo -e "$redBold Please provide a application name after 'create' option.$exitColor"
        fi
        ;;
    
    feature) featureToCreate=$2
        if [ -n "$featureToCreate" ]; then
            createFeatureFoldersStr "$featureToCreate"
        else
            echo -e "$redBold Please provide a Feature Name after 'feature' option.$exitColor"
        fi
        ;;
    help|*) displayHelp
       exit ;;
esac