<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LIVE VT Stream - Pro OTT</title>
    <!-- HLS.js প্লেয়ার লাইব্রেরি -->
    <script src="https://cdn.jsdelivr.net/npm/hls.js@latest"></script>
    <!-- Firebase SDK (Modular Version) -->
    <script type="module">
        import { initializeApp } from "https://www.gstatic.com/firebasejs/10.8.0/firebase-app.js";
        import { getAuth, createUserWithEmailAndPassword, signInWithEmailAndPassword, signOut, onAuthStateChanged } from "https://www.gstatic.com/firebasejs/10.8.0/firebase-auth.js";
        import { getFirestore, doc, setDoc, getDoc } from "https://www.gstatic.com/firebasejs/10.8.0/firebase-firestore.js";

        // আপনার ফায়ারবেজ কনফিগারেশন সরাসরি এখানে যুক্ত করা হয়েছে
        const firebaseConfig = {
          apiKey: "AIzaSyDrA82UWXgrUMenrIQpUl4vd1-axpkfsKU",
          authDomain: "alltv-8e7d3.firebaseapp.com",
          projectId: "alltv-8e7d3",
          storageBucket: "alltv-8e7d3.firebasestorage.app",
          messagingSenderId: "654835033152",
          appId: "1:654835033152:web:27a45e1fefcd216c716ba5",
          measurementId: "G-94RJ9XF74P"
        };

        const app = initializeApp(firebaseConfig);
        const auth = getAuth(app);
        const db = getFirestore(app);

        window.firebaseAuth = auth;
        window.firebaseDb = db;
        window.createUserWithEmailAndPassword = createUserWithEmailAndPassword;
        window.signInWithEmailAndPassword = signInWithEmailAndPassword;
        window.signOut = signOut;
        window.doc = doc;
        window.setDoc = setDoc;
        window.getDoc = getDoc;

        onAuthStateChanged(auth, async (user) => {
            if (user) {
                document.getElementById('userEmailDisplay').textContent = user.email;
                document.getElementById('authSection').style.display = 'none';
                document.getElementById('profileSection').style.display = 'flex';
                loadCloudFavorites(user.uid);
            } else {
                document.getElementById('userEmailDisplay').textContent = '';
                document.getElementById('authSection').style.display = 'flex';
                document.getElementById('profileSection').style.display = 'none';
            }
        });
    </script>

    <style>
        :root {
            --bg-color: #0b0b0b;
            --text-color: #ffffff;
            --panel-bg: #161616;
            --border-color: #222;
            --accent-color: #ff416c;
        }

        .light-mode {
            --bg-color: #f4f4f4;
            --text-color: #111111;
            --panel-bg: #ffffff;
            --border-color: #ccc;
            --accent-color: #007bff;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            transition: background 0.3s, color 0.3s;
        }

        body {
            background-color: var(--bg-color);
            color: var(--text-color);
            font-family: 'Rockwell', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }

        header {
            margin-top: 10px;
            margin-bottom: 10px;
            text-align: center;
        }
        .logo-img {
            max-width: 180px;
            height: auto;
            display: block;
            margin: 0 auto;
        }

        .user-bar {
            width: 100%;
            max-width: 900px;
            display: flex;
            justify-content: flex-end;
            margin-bottom: 15px;
            gap: 10px;
            align-items: center;
        }
        .auth-box {
            display: flex;
            gap: 5px;
        }
        .auth-box input {
            background: var(--panel-bg);
            color: var(--text-color);
            border: 1px solid var(--border-color);
            padding: 5px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-family: 'Rockwell';
        }

        .controls-container {
            width: 100%;
            max-width: 900px;
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 12px;
            margin-bottom: 15px;
        }

        .box {
            background: var(--panel-bg);
            padding: 10px 15px;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .box label {
            font-size: 13px;
            font-weight: bold;
            opacity: 0.8;
        }
        .box select, .box input {
            background: var(--bg-color);
            color: var(--text-color);
            border: 1px solid var(--border-color);
            padding: 6px 10px;
            border-radius: 6px;
            font-size: 13px;
            width: 65%;
            outline: none;
            font-family: 'Rockwell', sans-serif;
        }

        .toolbar {
            width: 100%;
            max-width: 900px;
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            gap: 10px;
            flex-wrap: wrap;
        }
        .btn {
            background: var(--panel-bg);
            color: var(--text-color);
            border: 1px solid var(--border-color);
            padding: 8px 12px;
            border-radius: 6px;
            cursor: pointer;
            font-family: 'Rockwell', sans-serif;
            font-size: 13px;
            font-weight: bold;
        }
        .btn:hover {
            background: var(--accent-color);
            color: #fff;
            border-color: var(--accent-color);
        }

        .video-container {
            width: 100%;
            max-width: 900px;
            background: var(--panel-bg);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
            border: 1px solid var(--border-color);
            aspect-ratio: 16 / 9;
        }

        video {
            width: 100%;
            height: 100%;
            display: block;
            background: #000;
        }

        footer {
            margin-top: 25px;
            font-size: 13px;
            opacity: 0.6;
        }

        @media(max-width: 600px) {
            .controls-container {
                grid-template-columns: 1fr;
            }
            .user-bar {
                flex-direction: column;
                align-items: flex-end;
            }
        }
    </style>
</head>
<body>

    <header>
        <img src="logo.png" alt="LIVE VT Logo" class="logo-img">
    </header>

    <div class="user-bar">
        <div id="authSection" class="auth-box">
            <input type="email" id="emailInput" placeholder="Email">
            <input type="password" id="passInput" placeholder="Password">
            <button class="btn" onclick="handleLogin()">Login</button>
            <button class="btn" onclick="handleSignup()">Sign Up</button>
        </div>
        <div id="profileSection" style="display: none; gap: 10px; align-items: center;">
            <span style="font-size: 12px; opacity: 0.8;">👤 <span id="userEmailDisplay"></span></span>
            <button class="btn" onclick="handleLogout()">Logout</button>
        </div>
    </div>

    <div class="controls-container">
        <div class="box">
            <label for="channelSelect">Channel:</label>
            <select id="channelSelect" onchange="changeChannel(this.value)">
                <option value="">Loading Playlist Channels...</option>
            </select>
        </div>

        <div class="box">
            <label for="timerSelect">Sleep Timer:</label>
            <select id="timerSelect" onchange="setSleepTimer(this.value)">
                <option value="0">Off</option>
                <option value="900">15 Mins</option>
                <option value="1800">30 Mins</option>
                <option value="3600">1 Hour</option>
            </select>
        </div>
    </div>

    <div class="toolbar">
        <input type="text" id="searchInput" placeholder="Search channel..." oninput="filterChannels()" style="background:var(--panel-bg); color:var(--text-color); border:1px solid var(--border-color); padding:8px 12px; border-radius:6px; width: 40%; font-family:'Rockwell'; font-size:13px;">
        
        <div style="display: flex; gap: 8px; flex-wrap: wrap;">
            <button class="btn" id="favBtn" onclick="toggleFavorite()">⭐ Mark Favorite</button>
            <button class="btn" id="viewFavBtn" onclick="toggleWatchlistView()">📂 View Watchlist</button>
            <button class="btn" onclick="toggleTheme()">☀️/🌙</button>
        </div>
    </div>

    <div class="video-container" id="videoContainer">
        <video id="video" controls autoplay muted></video>
    </div>

    <footer>
        <p>&copy; 2026 LIVE VT Platform. All Rights Reserved.</p>
    </footer>

    <script>
        var video = document.getElementById('video');
        var channelSelect = document.getElementById('channelSelect');
        var hls = null;
        var sleepTimer = null;
        var allChannels = []; 
        var cloudFavorites = [];
        var viewingFavoritesOnly = false;

        var playlistUrl = 'https://iptv-org.github.io/iptv/index.m3u';

        fetch(playlistUrl)
            .then(response => response.text())
            .then(data => {
                var lines = data.split('\n');
                allChannels = [];
                var channelName = '';

                lines.forEach(line => {
                    line = line.trim();
                    if (line.startsWith('#EXTINF:')) {
                        var parts = line.split(',');
                        if (parts.length > 1) {
                            channelName = parts[parts.length - 1];
                        }
                    } else if (line.startsWith('http')) {
                        if (channelName) {
                            allChannels.push({ name: channelName, url: line });
                            channelName = '';
                        }
                    }
                });

                populateDropdown(allChannels);
                if (allChannels.length > 0) {
                    playChannel(allChannels[0].url);
                }
            });

        function populateDropdown(channels) {
            channelSelect.innerHTML = '';
            channels.forEach(ch => {
                var option = document.createElement('option');
                option.value = ch.url;
                let isFav = cloudFavorites.some(fav => fav.url === ch.url);
                option.textContent = isFav ? "⭐ " + ch.name : ch.name;
                channelSelect.appendChild(option);
            });
        }

        function playChannel(url) {
            if (!url) return;
            if (video.canPlayType('application/vnd.apple.mpegurl')) {
                video.src = url;
                video.addEventListener('loadedmetadata', function() { video.play(); });
            } else if (Hls.isSupported()) {
                if (hls) { hls.destroy(); }
                hls = new Hls();
                hls.loadSource(url);
                hls.attachMedia(video);
                hls.on(Hls.Events.MANIFEST_PARSED, function() { video.play(); });
            } else {
                video.src = url;
                video.play();
            }
        }

        function changeChannel(url) { playChannel(url); }

        async function handleSignup() {
            let email = document.getElementById('emailInput').value;
            let pass = document.getElementById('passInput').value;
            try {
                await window.createUserWithEmailAndPassword(window.firebaseAuth, email, pass);
                alert("Account created successfully!");
            } catch (error) { alert(error.message); }
        }

        async function handleLogin() {
            let email = document.getElementById('emailInput').value;
            let pass = document.getElementById('passInput').value;
            try {
                await window.signInWithEmailAndPassword(window.firebaseAuth, email, pass);
                alert("Logged in successfully!");
            } catch (error) { alert(error.message); }
        }

        async function handleLogout() {
            await window.signOut(window.firebaseAuth);
            cloudFavorites = [];
            populateDropdown(allChannels);
            alert("Logged out!");
        }

        async function loadCloudFavorites(uid) {
            try {
                const docRef = window.doc(window.firebaseDb, "users", uid);
                const docSnap = await window.getDoc(docRef);
                if (docSnap.exists()) {
                    cloudFavorites = docSnap.data().favorites || [];
                } else {
                    cloudFavorites = [];
                }
                populateDropdown(allChannels);
            } catch (error) { console.error("Error loading favorites", error); }
        }

        async function saveCloudFavorites(uid) {
            try {
                const docRef = window.doc(window.firebaseDb, "users", uid);
                await window.setDoc(docRef, { favorites: cloudFavorites });
            } catch (error) { console.error("Error saving favorites", error); }
        }

        async function toggleFavorite() {
            const user = window.firebaseAuth.currentUser;
            if (!user) {
                alert("Please login first to save favorites to your cloud profile!");
                return;
            }

            var selectedUrl = channelSelect.value;
            if(!selectedUrl) return;
            var selectedText = channelSelect.options[channelSelect.selectedIndex].text.replace("⭐ ", "");
            
            let index = cloudFavorites.findIndex(fav => fav.url === selectedUrl);
            if (index === -1) {
                cloudFavorites.push({ name: selectedText, url: selectedUrl });
                alert(selectedText + " added to your Cloud Watchlist!");
            } else {
                cloudFavorites.splice(index, 1);
                alert(selectedText + " removed from your Watchlist.");
            }

            await saveCloudFavorites(user.uid);
            filterChannels();
        }

        function toggleWatchlistView() {
            var favBtnText = document.getElementById('viewFavBtn');
            if (!viewingFavoritesOnly) {
                if (cloudFavorites.length === 0) {
                    alert("Your watchlist is empty!");
                    return;
                }
                viewingFavoritesOnly = true;
                favBtnText.textContent = "📂 Show All Channels";
                populateDropdown(cloudFavorites);
            } else {
                viewingFavoritesOnly = false;
                favBtnText.textContent = "📂 View Watchlist";
                populateDropdown(allChannels);
            }
        }

        function filterChannels() {
            var input = document.getElementById('searchInput').value.toLowerCase();
            var sourceList = viewingFavoritesOnly ? cloudFavorites : allChannels;
            var filtered = sourceList.filter(ch => ch.name.toLowerCase().includes(input));
            
            channelSelect.innerHTML = '';
            if (filtered.length === 0) {
                var option = document.createElement('option');
                option.textContent = "No channels found";
                channelSelect.appendChild(option);
                return;
            }

            filtered.forEach(ch => {
                var option = document.createElement('option');
                option.value = ch.url;
                let isFav = cloudFavorites.some(fav => fav.url === ch.url);
                option.textContent = isFav ? "⭐ " + ch.name : ch.name;
                channelSelect.appendChild(option);
            });
        }

        function setSleepTimer(seconds) {
            if (sleepTimer) { clearTimeout(sleepTimer); sleepTimer = null; }
            seconds = parseInt(seconds);
            if (seconds > 0) {
                sleepTimer = setTimeout(function() {
                    video.pause();
                    video.src = "";
                    alert("Sleep Timer: Video paused automatically.");
                }, seconds * 1000);
            }
        }

        function toggleTheme() { document.body.classList.toggle('light-mode'); }
    </script>
</body>
</html>
