cask "quietvibestatus" do
  version "1.0.4"
  sha256 "4ed978054fb65fb599c93c996a4e2f23fdf84fd2b209865364c0ae1e51da49e0"

  url "https://github.com/quietapps/QuietVibeStatus/releases/download/#{version}/QuietVibeStatus-#{version}.zip"
  name "Quiet Vibe Status"
  desc "Notch panel that watches your AI coding agents and lets you approve or answer from anywhere"
  homepage "https://github.com/quietapps/QuietVibeStatus"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates false
  depends_on macos: :sonoma

  app "Quiet Vibe Status.app"

  # Build is not signed with an Apple Developer ID. Make the app launchable on
  # any Mac out of the box:
  #   1. Strip ALL extended attributes (com.apple.quarantine, com.apple.macl,
  #      com.apple.provenance) so Gatekeeper does not block launch.
  #   2. Force-register the bundle with Launch Services so double-clicking from
  #      Finder / Dock launches the real binary.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/Quiet Vibe Status.app"],
                   sudo: false
    system_command "/System/Library/Frameworks/CoreServices.framework/" \
                   "Versions/A/Frameworks/LaunchServices.framework/" \
                   "Versions/A/Support/lsregister",
                   args: ["-f", "#{appdir}/Quiet Vibe Status.app"],
                   sudo: false,
                   must_succeed: false
  end

  zap trash: [
    "~/Library/Caches/app.quiet.QuietVibeStatus",
    "~/Library/Preferences/app.quiet.QuietVibeStatus.plist",
    "~/Library/Saved Application State/app.quiet.QuietVibeStatus.savedState",
    "~/.quietvibestatus",
  ]

  caveats <<~EOS
    Quiet Vibe Status is distributed unsigned. The post-install hook strips
    Gatekeeper attributes automatically, but if the app refuses to launch
    on a fresh Mac, do this once:

      1. Open Finder → /Applications
      2. Right-click "Quiet Vibe Status.app" → Open
      3. Click "Open" in the dialog
      4. macOS remembers your choice for every future launch

    Or run this in Terminal once after install:
      xattr -cr "/Applications/Quiet Vibe Status.app"

    On first launch, the onboarding flow offers to connect whichever coding
    agents it finds (Claude Code, Codex, Gemini CLI, Cursor Agent).
  EOS
end


