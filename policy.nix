{ lib, ... }: let
  inherit (lib) optionals optionalAttrs;
in {
  policies = {

    ### TELEMETRY ###
    DisableTelemetry = true;
    DisableFirefoxStudies = true;

    ### OTHER MOZILLA CRAP ###
    DisablePocket = true;

    UserMessaging = {
      ExtensionRecommendations = false;
      FeatureRecommendations = false;
      UrlbarInterventions = false;
      MoreFromMozilla = false;
    };

    FirefoxHome = {
      TopSites = false;
      SponsoredTopSites = false;
      Highlights = false;
      Pocket = false;
      SponsoredPocket = false;
      Snippets = false;
    };

    ### SECURITY/PRIVACY ###
    HttpsOnlyMode = "force_enabled";

    Permissions.Notifications = {
      BlockNewRequests = true;
      Locked = true;
    };

    # DRM is Evil
    EncryptedMediaExtensions = {
      Enabled = false;
      Locked = true;
    };

    ### TWEAKS ###

    DontCheckDefaultBrowser = true;

    # remove the “Set As Desktop Background” menuitem when right clicking images
    DisableSetDesktopBackground = true;

    FirefoxSuggest = {
      WebSuggestions = false;
      SponsoredSuggestions = false;
      ImproveSuggest = false;
      # Locked = true;
    };

    # "Disable the menus for reporting sites (Submit Feedback, Report Deceptive Site)."
    DisableFeedbackCommands = true;

    ExtensionSettings = {
      "uBlock0@raymondhill.net" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        installation_mode = "normal_installed";
      };
      "addon@darkreader.org" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
        installation_mode = "normal_installed";
      };
    };

    ###

    Preferences = let
      default = value: {
        Status = "default";
        Value = value;
      };

      locked = value: {
        Status = "locked";
        Value = value;
      };
    in {
      ### TWEAKS ###
    
      # Don't close FF after closing all tabs
      "browser.tabs.closeWindowWithLastTab" = locked false;

      # Always use the XDG Portal filepicker instead of the GTK one
      "widget.use-xdg-desktop-portal.file-picker" = locked 1;

      # When downloading files, always open the filepicker instead of
      # automatically saving the file to Downloads folder
      "browser.download.useDownloadDir" = locked false;

      # Don't show a warning when opening about:config
      "browser.aboutConfig.showWarning" = locked false;

      # Use rounded bottom window corners on Linux
      "widget.gtk.rounded-bottom-corners.enabled" = locked true;

      # Trim https:// from the url bar
      "browser.urlbar.trimHttps" = locked true;

      # Hide "More from Mozilla" in settings
      "browser.preferences.moreFromMozilla" = locked false;

      # No distractions while typing in the url bar
      "browser.urlbar.suggest.engines" = false;
      "browser.urlbar.suggest.history" = false;
      "browser.urlbar.suggest.recentsearches" = false;
      "browser.urlbar.suggest.bookmark" = false;
      "browser.urlbar.suggest.topsites" = false; # "Shortcuts" - includes facebook, twitter, etc.

      ### TELEMETRY (shouldn't be needed because of DisableTelemetry policy, but it doesn't hurt to still set these) ###

      # Firefox Home (Activity Stream)
      "browser.newtabpage.activity-stream.telemetry" = locked false;
      "browser.newtabpage.activity-stream.feeds.telemetry" = locked false;

      ### SECURITY/PRIVACY ###
    
      "browser.contentblocking.category" = locked "strict";

      # GPC is a privacy signal that tells websites that the user
      # doesn’t want to be tracked and doesn’t want their data to be sold.
      # Like DNT, but actually honored by many highly ranked sites [1].
      # [TEST] https://global-privacy-control.glitch.me/
      # [1] https://github.com/arkenfox/user.js/issues/1542#issuecomment-1279823954
      "privacy.globalprivacycontrol.enabled" = locked true;

      # Display "Not Secure" text on HTTP sites
      # [TEST] http://www.http2demo.io/
      "security.insecure_connection_text.enabled" = locked true;
      "security.insecure_connection_text.pbmode.enabled" = locked true;

      # Display advanced information on Insecure Connection warning pages
      # [TEST] https://expired.badssl.com/
      "browser.xul.error_pages.expert_bad_cert" = locked true;

      # Disable crash reports
      "browser.tabs.crashReporting.sendReport" = locked false;

      ### ANNOYING WEB APIs ###

      # Websites can resize windows which they created with `window.open()`. I haven't
      # seen that in the wild, but it sounds pointless and doesn't work on Android/iOS anyway
      # [TEST] https://www.w3schools.com/jsref/tryit.asp?filename=tryjsref_win_resizeto
      "dom.disable_window_move_resize" = locked true;

      # Disable Push Notifications. This also reduces the amount of background network requests
      "dom.webnotifications.enabled" = locked false;
      "dom.push.enabled" = locked false;
      "dom.push.serverURL" = locked "";
    };

  };
}
