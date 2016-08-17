#!/usr/bin/env bash

##############################################################################
##
##  Script switch YH-IOS apps for UN*X
##
##############################################################################

case "$1" in
  yonghui|shengyiplus|qiyoutong|yonghuitest|test)
    # bundle exec ruby config/app_keeper.rb --plist --assets --constant
    bundle exec ruby config/app_keeper.rb --app="$1" --plist --assets --constant
  ;;
  pgyer)
    bundle exec ruby config/app_keeper.rb --app="$(cat .current-app)" --pgyer
  ;;
  all)
    echo 'TODO'
  ;;
  *)
  test -z "$1" && echo "current app: $(cat .current-app)" || echo "unknown argument - $1"
  ;;
esac