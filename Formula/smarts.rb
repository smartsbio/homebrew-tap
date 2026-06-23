class Smarts < Formula
  desc "smarts.bio command-line interface"
  homepage "https://smarts.bio"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartsbio/smarts-bio-cli/releases/download/v0.1.5/smarts-aarch64-apple-darwin.tar.xz"
      sha256 "383563b5bc8d86b637a7231d17e521bea6e5164b74618355b7923408137539e6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartsbio/smarts-bio-cli/releases/download/v0.1.5/smarts-x86_64-apple-darwin.tar.xz"
      sha256 "b0a99c49100033a9117711a741f3b85a3f8d4cc6c4f72eb01ba60e2e0b365b25"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartsbio/smarts-bio-cli/releases/download/v0.1.5/smarts-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "97af1393e30ea240c5a25ce2ec3002a66d976b6b1e019d73d0515cd4671224e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartsbio/smarts-bio-cli/releases/download/v0.1.5/smarts-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c2f9d4657242dab0fb25ef7e4433dd12106642d0d2b5d31969fa40997ada20f0"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "smarts" if OS.mac? && Hardware::CPU.arm?
    bin.install "smarts" if OS.mac? && Hardware::CPU.intel?
    bin.install "smarts" if OS.linux? && Hardware::CPU.arm?
    bin.install "smarts" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
