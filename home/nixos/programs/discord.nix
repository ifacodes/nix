{ ... }: {

  programs.nixcord = {
    enable = true;

    discord.enable = false;
    discord.vencord.enable = false;
    discord.equicord.enable = true;
    discord.krisp.enable = true;
    discord.openASAR.enable = true;

    equibop.enable = true;

    quickCss = ''
      :root {
        /* Theme Background */
        --theme-background-image: url(https://github.com/computer-catt/PurplePrune/blob/main/Assets/DayTheme.webp?raw=true) repeat-x center / auto 100% fixed;
      }
    '';

    config = {
      useQuickCss = true;
      enabledThemeLinks = [
        "https://raw.githubusercontent.com/computer-catt/PurplePrune/main/PurplePrune.css"
      ];
      plugins = {
        alwaysAnimate.enable = true;
        betterGifAltText.enable = true;
        betterSessions.enable = true;
        betterSettings.enable = true;
        betterUploadButton.enable = true;
        clearUrls.enable = true;
        copyEmojiMarkdown.enable = true;
        copyStickerLinks.enable = true;
        copyFileContents.enable = true;
        crashHandler.enable = true;
        customRpc.enable = true;
        disableDeepLinks.enable = true;
        dearrow.enable = true;
        expressionCloner.enable = true;
        fixCodeblockGap.enable = true;
        fixImagesQuality.enable = true;
        fixSpotifyEmbeds.enable = true;
        fixYoutubeEmbeds.enable = true;
        # friendsSince.enable = true;
        fullSearchContext.enable = true;
        gifPaste.enable = true;
        implicitRelationships.enable = true;
        mentionAvatars.enable = true;
        messageLinkEmbeds.enable = true;
        openInApp.enable = true;
        petpet.enable = true;
        relationshipNotifier.enable = true;
        showHiddenThings.enable = true;
        stickerPaste.enable = true;
        themeAttributes.enable = true;
        validReply.enable = true;
        validUser.enable = true;
        viewIcons.enable = true;
        voiceDownload.enable = true;
        voiceMessages.enable = true;
        webContextMenus = {
          enable = true;
          addBack = true;
        };
        # webRichPresence.enable = true;
        webScreenShareFixes.enable = true;

        # equicord plugins
        autoZipper.enable = true;
        clickableRoles.enable = true;
        # collapsibleUi = {
        #   enable = true;
        #   channelListCollapsed = true;
        # };
        equibopStreamFixes.enable = true;
        equicordToolbox.enable = true;
        messageColors.enable = true;
        micLoopbackTester.enable = true;
        searchFix.enable = true;
        typingIndicator.enable = true;
        typingTweaks.enable = true;
        webRichPresence.enable = true;

      };
    };

  };

}

