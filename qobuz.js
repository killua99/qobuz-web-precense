registerParser({
  id: "killua99_qobuz.com_k99",
  domain: "play.qobuz.com",
  authors: "killua99",
  authorsLinks: "https://codeberg.org/killua99",
  title: "qobuz",
  version: "0.1.0",
  description: "Global on-demand music streaming with playlists and recommendations.",
  category: "platform",
  tags: [],
  urlPatterns: ["/.*/"],
  fn: function () {
    let title = document.querySelector("[class='player__track-overflow']")?.textContent;
    let artist = document.querySelector("[class='player__track-album'] a")?.textContent;
    let image = document.querySelector("[class='player__track-cover'] img")?.src;
    const timePassed = document.querySelectorAll("span[class='player__track-time-text']")[0]?.textContent.trim() || "";
    const duration = document.querySelectorAll("span[class='player__track-time-text']")[1]?.textContent.trim() || "";
    const sourceUrl = document.querySelector("a[class='player__track-name']")?.href;
    const source = "qobuz";
    const songUrl = sourceUrl || "https://play.qobuz.com/";
    const isPlaying = Boolean(document.querySelector("[class='player__action-pause']"));

    if (!title) title = document.querySelector("head title")?.textContent.split(" - ").slice(0, -2).join(" - ");
    if (!artist) artist = document.querySelector("head title")?.textContent.split(" - ").slice(-2)[0];
    //if (!image) image = document.querySelector(`img[alt='${title}']`)?.src.replace("500x500", "200x200");
  },
});
player__track-overflow
