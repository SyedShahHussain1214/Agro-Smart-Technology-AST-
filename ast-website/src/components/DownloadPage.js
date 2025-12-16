import React, { useState } from 'react';
import './DownloadPage.css';

const DownloadPage = () => {
  const [latestVersion] = useState('latest');
  const [releaseDate] = useState('June 2024');

  const downloads = [
    {
      id: 'apk',
      platform: 'Android',
      type: 'APK',
      version: '1.0.1',
      fileSize: '85 MB',
      icon: '📱',
      minAndroid: 'Android 8.0+',
      features: [
        'Voice Q&A with Gemini AI',
        'Disease Detection with Vision AI',
        'Real-Time Weather Forecast',
        'Live Mandi Rates',
        'Urdu & English Support',
        'Offline Capability'
      ],
      downloadUrl: '/downloads/AgroSmartApp-latest.apk',
      changelog: [
        '✅ Full Gemini AI integration',
        '✅ Crop disease detection with image analysis',
        '✅ Real-time weather with agricultural recommendations',
        '✅ Live mandi rates from Pakistani markets',
        '✅ Bilingual Urdu/English interface',
        '✅ Offline mode with local caching'
      ]
    },
  ];

  const systemRequirements = {
    android: {
      minimum: 'Android 8.0',
      recommended: 'Android 10+',
      ram: '2 GB minimum, 4 GB recommended',
      storage: '100 MB free storage',
      internet: 'For real-time features'
    }
  };

  const handleDownload = (downloadUrl, fileName) => {
    // In production, this would point to actual file server
    const link = document.createElement('a');
    link.href = downloadUrl;
    link.download = fileName;
    link.click();
  };

  return (
    <div className="download-page">
      {/* Hero Section */}
      <section className="download-hero">
        <div className="hero-content">
          <h1>Download Agro Smart Technology</h1>
          <p className="subtitle">Get the complete AI-powered farming assistant</p>
          <p className="current-version">Current Version: {latestVersion} | Released: {releaseDate}</p>
        </div>
      </section>

      {/* Main Download Card */}
      <section className="download-main">
        <div className="container">
          {downloads.map((download) => (
            <div key={download.id} className="download-card">
              <div className="platform-header">
                <span className="platform-icon">{download.icon}</span>
                <div>
                  <h2>{download.platform}</h2>
                  <p className="min-req">{download.minAndroid}</p>
                </div>
              </div>

              <div className="download-details">
                <div className="detail-item">
                  <span className="label">Version</span>
                  <span className="value">{download.version}</span>
                </div>
                <div className="detail-item">
                  <span className="label">File Size</span>
                  <span className="value">{download.fileSize}</span>
                </div>
                <div className="detail-item">
                  <span className="label">Type</span>
                  <span className="value">{download.type}</span>
                </div>
              </div>

              <button 
                className="download-btn"
                onClick={() => handleDownload(download.downloadUrl, `AgroSmartApp-latest.apk`)}
              >
                <span className="btn-icon">⬇️</span>
                Download {download.fileSize}
              </button>

              <div className="features-section">
                <h3>Key Features</h3>
                <ul className="features-list">
                  {download.features.map((feature) => (
                    <li key={feature}>
                      <span className="check">✓</span>
                      {feature}
                    </li>
                  ))}
                </ul>
              </div>

              <div className="changelog-section">
                <h3>Latest Updates</h3>
                <ul className="changelog-list">
                  {download.changelog.map((item) => (
                    <li key={item}>{item}</li>
                  ))}
                </ul>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* System Requirements */}
      <section className="system-requirements">
        <div className="container">
          <h2>System Requirements</h2>
          
          <div className="requirements-grid">
            <div className="requirement-card">
              <h3>📱 Android</h3>
              <ul>
                <li><strong>Minimum:</strong> {systemRequirements.android.minimum}</li>
                <li><strong>Recommended:</strong> {systemRequirements.android.recommended}</li>
                <li><strong>RAM:</strong> {systemRequirements.android.ram}</li>
                <li><strong>Storage:</strong> {systemRequirements.android.storage}</li>
                <li><strong>Connection:</strong> {systemRequirements.android.internet}</li>
              </ul>
            </div>
          </div>
        </div>
      </section>

      {/* Installation Guide */}
      <section className="installation-guide">
        <div className="container">
          <h2>Installation Guide</h2>
          
          <div className="steps-container">
            <div className="step">
              <div className="step-number">1</div>
              <div className="step-content">
                <h3>Download APK</h3>
                <p>Click the download button above to download the APK file to your device</p>
              </div>
            </div>

            <div className="step">
              <div className="step-number">2</div>
              <div className="step-content">
                <h3>Enable Unknown Sources</h3>
                <p>Go to Settings → Security → Enable "Unknown Sources" to allow app installation</p>
              </div>
            </div>

            <div className="step">
              <div className="step-number">3</div>
              <div className="step-content">
                <h3>Open File Manager</h3>
                <p>Navigate to your Downloads folder and find the APK file</p>
              </div>
            </div>

            <div className="step">
              <div className="step-number">4</div>
              <div className="step-content">
                <h3>Install App</h3>
                <p>Tap the APK file and follow the installation prompts</p>
              </div>
            </div>

            <div className="step">
              <div className="step-number">5</div>
              <div className="step-content">
                <h3>Grant Permissions</h3>
                <p>Allow microphone and camera access for voice and image features</p>
              </div>
            </div>

            <div className="step">
              <div className="step-number">6</div>
              <div className="step-content">
                <h3>Start Using</h3>
                <p>Open the app and start asking agricultural questions in Urdu!</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* FAQ */}
      <section className="faq-section">
        <div className="container">
          <h2>Frequently Asked Questions</h2>
          
          <div className="faq-items">
            <details className="faq-item">
              <summary>Is the app free to download?</summary>
              <p>Yes, Agro Smart Technology is completely free to download and use!</p>
            </details>

            <details className="faq-item">
              <summary>Do I need internet to use all features?</summary>
              <p>Most AI features require internet for real-time data. However, the app has offline mode for basic functionality and cached data.</p>
            </details>

            <details className="faq-item">
              <summary>Is my data safe?</summary>
              <p>Yes, all data is encrypted and uses Firebase's secure infrastructure. We do not store personal agricultural data on external servers.</p>
            </details>

            <details className="faq-item">
              <summary>Can I use the app in English?</summary>
              <p>Absolutely! The app supports both Urdu and English with a simple language toggle in the settings.</p>
            </details>

            <details className="faq-item">
              <summary>How often are the mandi rates updated?</summary>
              <p>Mandi rates are updated multiple times daily from Pakistani agricultural markets.</p>
            </details>

            <details className="faq-item">
              <summary>What if I encounter bugs?</summary>
              <p>Please report any issues to our team. We're constantly improving the app based on user feedback.</p>
            </details>
          </div>
        </div>
      </section>

      {/* Support Section */}
      <section className="support-section">
        <div className="container">
          <h2>Need Help?</h2>
          <div className="support-cards">
            <div className="support-card">
              <h3>📧 Email</h3>
              <p>support@agrosmart.pk</p>
            </div>
            <div className="support-card">
              <h3>💬 WhatsApp</h3>
              <p>+92-XXX-XXXXXXX</p>
            </div>
            <div className="support-card">
              <h3>📱 Social Media</h3>
              <p>@AgroSmartTech</p>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
};

export default DownloadPage;
