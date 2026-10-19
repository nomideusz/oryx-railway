# Deploy and Host Oryx on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/oryx?referralCode=sLjDXb&utm_medium=integration&utm_source=button&utm_campaign=oryx)

[Oryx](https://github.com/ossrs/oryx) (formerly SRS Stack) is the all-in-one live streaming server from the team behind [SRS](https://ossrs.io/). Stream into it from OBS over RTMP and play the stream back as HLS or HTTP-FLV. You can also restream to YouTube, Twitch, Facebook and others at the same time, loop a video file as a 24/7 virtual live stream, or record streams to MP4. It all runs from one web console.

## About Hosting Oryx

It's one service, a Railway volume, and a TCP proxy for RTMP.

- **Locked from the first second.** Oryx normally asks whoever opens it first to set the console password. Here the password comes from the `MGMT_PASSWORD` variable, so the console asks you to log in from the start.
- **The right RTMP address.** On Railway, OBS has to stream to the TCP proxy, which is on a different host than the console. The console's Streaming page shows that proxy address, so you can copy it straight into OBS.
- **Playback on your domain.** HLS (`.m3u8`) and HTTP-FLV (`.flv`) are served over HTTPS on the service's Railway domain, ready for a web player or a page you embed it in.
- **Survives redeploys.** Stream keys, restream targets, virtual-live playlists and recordings live on the volume. On a redeploy Oryx saves its settings first.

## Common Use Cases

- Restream one OBS stream to YouTube, Twitch, Facebook and more at once, without the extra upload from your home connection
- Run a 24/7 "virtual live" channel (lo-fi music, a looping event replay) from an uploaded video, with no PC left on at home
- Host your own live stream with HLS playback on a web page, and record it to MP4

## Dependencies for Oryx Hosting

- Nothing else: Oryx bundles its own Redis, SRS media server and FFmpeg

### Deployment Dependencies

- [Oryx on GitHub](https://github.com/ossrs/oryx)
- [Oryx documentation](https://ossrs.io/lts/en-us/docs/v6/doc/getting-started-oryx)
- [Template source on GitHub](https://github.com/two-workspaces/oryx)

### Implementation Details

**Sign in.** Open the service's Railway domain and log in with the `MGMT_PASSWORD` value from the Variables tab. The login page says the password is stored in `/data/config/.env`; on this template it's the variable instead. To change it, edit the variable and redeploy.

**Stream from OBS.** Go to Scenarios → Streaming. Copy the **Server:** (`rtmp://xyz.proxy.rlwy.net:12345/live/`) into OBS under Settings → Stream → Custom, and the **Stream Key:** next to it. The key includes a secret, so nobody else can publish to your server. The same address is also in the deploy logs, on the line starting "stream from OBS to".

**Watch.** The Streaming page lists the HLS and FLV playback URLs on your Railway domain, and has a built-in player.

**Restream.** Scenarios → Forward: paste the RTMP server and stream key from YouTube, Twitch or another platform, and Oryx pushes whatever you stream in to each enabled target.

**Bandwidth costs.** Railway bills outbound traffic per GB. A 6 Mbps stream is about 2.7 GB per hour for each restream target or viewer. A 24/7 virtual live stream to one platform comes to roughly 2 TB a month. Lower the bitrate (or use Scenarios → Transcoding) if that matters to you. Inbound traffic from OBS is free.

**Memory.** Oryx idles at about 30 MB. Each restream, virtual live or transcode task runs its own FFmpeg process, and transcoding also uses a lot of CPU.

**Limits on Railway.** Railway's TCP proxy carries TCP only, so WebRTC (WHIP/WHEP) and SRT, which use UDP, won't work here. RTMP in plus HLS/FLV out cover OBS and every major platform. The console's HTTPS/Let's Encrypt setting isn't needed: Railway already serves your domain over HTTPS.

### 中文说明

用 Railway 域名打开控制台，密码是变量里的 `MGMT_PASSWORD`。把 `REACT_APP_LOCALE` 设为 `zh` 即为中文界面。在“应用场景 → 推拉流”页面复制推流地址（Railway 的 TCP Proxy 地址）和推流密钥到 OBS。支持多平台转播、虚拟直播（循环播放视频 24/7 直播）、录制，以及在你的域名上用 HLS/FLV 播放。Railway 只支持 TCP，所以 WebRTC 和 SRT 不可用。出站流量按 GB 计费：6 Mbps 的码率每路每小时约 2.7 GB。

## Why Deploy Oryx on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Oryx on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
