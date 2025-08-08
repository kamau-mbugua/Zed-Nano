# Security Scan Exceptions

This document explains security scan findings that are safe to ignore due to third-party package implementations.

## Accepted Findings - Third-Party Packages

### Firebase Cloud Messaging (FCM)
**Components:**
- `io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingReceiver`
- `com.google.firebase.iid.FirebaseInstanceIdReceiver`

**Permission:** `com.google.android.c2dm.permission.SEND`
**Status:** ✅ ACCEPTED
**Reason:** Official Google Firebase service components with proper security implementation
**Package:** `firebase_messaging: ^16.0.0`

### Google Sign-In Service
**Component:** `com.google.android.gms.auth.api.signin.RevocationBoundService`
**Permission:** `com.google.android.gms.auth.api.signin.permission.REVOCATION_NOTIFICATION`
**Status:** ✅ ACCEPTED
**Reason:** Official Google Play Services authentication component
**Package:** `google_sign_in: ^7.1.1`

### AndroidX Profile Installer
**Component:** `androidx.profileinstaller.ProfileInstallReceiver`
**Permission:** `android.permission.DUMP`
**Status:** ✅ ACCEPTED
**Reason:** Official AndroidX framework component for app performance optimization
**Package:** Part of AndroidX framework

### Firebase Auth Activity
**Component:** `com.google.firebase.auth.internal.GenericIdpActivity`
**Permission:** None (exported=true)
**Status:** ✅ ACCEPTED
**Reason:** Official Firebase Authentication activity for OAuth flows (Google, Facebook, etc.)
**Package:** `firebase_auth: ^6.0.0`
**Note:** Required for social authentication redirects

### Facebook Custom Tab Activity
**Component:** `com.facebook.CustomTabActivity`
**Permission:** None (exported=true)
**Status:** ✅ ACCEPTED
**Reason:** Official Facebook SDK activity for Custom Tabs authentication flow
**Package:** `flutter_facebook_auth: ^7.1.1`
**Note:** Required for Facebook login via Custom Tabs

## Verification
- All flagged components are from trusted Google/Android sources
- No custom exported components in app manifest
- Permissions are properly scoped by package authors
- Components not directly declared in app's AndroidManifest.xml

## Additional Security Findings - Third-Party Packages

### 1. External Storage Access
**Components:** 
- `io.flutter.plugins.pathprovider.Messages`
- `io.flutter.plugins.pathprovider.PathProviderPlugin`

**CWE:** CWE-276 (Incorrect Default Permissions)
**Status:** ✅ ACCEPTED
**Reason:** Path provider plugin uses app-private directories, not external storage. On Android 10+, uses scoped storage which is secure.
**Package:** `path_provider` (Flutter official plugin)

### 2. Hardcoded Sensitive Information
**Components:**
- `com.baseflow.permissionhandler.PermissionUtils.java`
- `com.it_nomads.fluttersecurestorage.ciphers.StorageCipherFactory.java`
- `com.tekartik.sqflite.Constant.java`
- `io.flutter.embedding.android.*`
- `io.flutter.plugins.firebase.*.Constants.java`
- `io.flutter.plugins.imagepicker.ImagePickerCache.java`
- `io.grpc.internal.*`

**CWE:** CWE-312 (Cleartext Storage of Sensitive Information)
**Status:** ✅ ACCEPTED
**Reason:** These are configuration constants in third-party libraries, not application secrets. Flutter framework and official plugins contain build-time configuration, not runtime sensitive data.

### 3. Insecure Random Number Generator
**Components:**
- `io.grpc.internal.DnsNameResolver.java`
- `io.grpc.internal.ExponentialBackoffPolicy.java`
- `io.grpc.internal.*LoadBalancer*.java`
- `io.grpc.internal.RetriableStream.java`
- `io.grpc.okhttp.OkHttpClientTransport.java`
- `io.grpc.util.*LoadBalancer*.java`

**CWE:** CWE-330 (Use of Insufficiently Random Values)
**Status:** ✅ ACCEPTED
**Reason:** gRPC networking library uses random for load balancing, retry timing, and connection management - not for cryptographic purposes. Application uses `Random.secure()` for security-sensitive operations.

### 4. IP Address Disclosure
**Components:**
- `io.grpc.okhttp.OkHttpClientTransport.java`
- `io.grpc.okhttp.OkHttpServerTransport.java`

**CWE:** CWE-200 (Information Exposure)
**Status:** ✅ ACCEPTED
**Reason:** Standard networking behavior in HTTP client libraries. IP addresses are necessary for network communication and are not sensitive in business app context.

### 5. SQL Injection Risk
**Component:** `com.tekartik.sqflite.Database.java`
**CWE:** CWE-89 (SQL Injection)
**Status:** ✅ ACCEPTED
**Reason:** Application code uses parameterized queries exclusively. The sqflite library supports both raw and parameterized queries, but application follows secure coding practices.

### 6. CBC Encryption Vulnerability
**Component:** `com.it_nomads.fluttersecurestorage.ciphers.StorageCipher18Implementation.java`
**CWE:** CWE-649 (Reliance on Obfuscation or Encryption)
**Status:** ✅ ACCEPTED
**Reason:** Using latest flutter_secure_storage version which implements AES-GCM on newer Android versions. For older versions, the CBC implementation is acceptable for local device storage with additional app-level encryption.

## Security Mitigation Strategies

### Application-Level Security:
1. **Data Storage:** Use app-private directories only
2. **SQL Queries:** Parameterized queries exclusively  
3. **Random Generation:** `Random.secure()` for security operations
4. **Network Security:** HTTPS with certificate validation
5. **Secrets Management:** Environment variables, no hardcoded secrets

### Third-Party Package Security:
1. **Regular Updates:** Keep packages updated to latest versions
2. **Security Monitoring:** Monitor package vulnerability databases
3. **Minimal Permissions:** Use least-privilege principle
4. **Code Review:** Review third-party package usage

### Framework Security:
1. **Flutter Security:** Follow Flutter security best practices
2. **Android Security:** Target latest Android API levels
3. **Platform Security:** Leverage platform security features

## Risk Assessment

### HIGH RISK: ❌ None identified in application code
### MEDIUM RISK: ⚠️ None requiring immediate action  
### LOW RISK: ✅ All findings are in trusted third-party packages
### INFORMATIONAL: ℹ️ Framework and library configuration files

## Compliance Status

- **OWASP MASVS:** Compliant with mobile security standards
- **CWE Standards:** All findings documented and justified
- **Industry Standards:** Following Flutter and Android security guidelines
- **Third-Party Security:** Using trusted, maintained packages only

## Android SDK Security Configuration

### Minimum SDK Version
**Current Setting:** API 26 (Android 8.0)
**Rationale:** 
- Balances security with device compatibility
- Eliminates security scanner warnings about vulnerable Android versions
- Supports 97%+ of active Android devices (as of 2025)
- Includes modern security features like:
  - Runtime permissions model improvements
  - Background execution limits
  - Enhanced cryptographic standards
  - Improved app sandboxing

### Device Compatibility Impact
- **Supported:** Android 8.0+ (2017 and newer)
- **Market Coverage:** ~97% of active devices
- **Excluded:** Very old devices (Android 6.0-7.1, ~3% market share)

### Security Benefits
- Modern TLS/SSL implementations
- Enhanced permission model
- Better app isolation
- Reduced attack surface
- Compliance with current security standards

## Review Date
Last reviewed: 2025-08-08
Next review: 2025-11-08 (quarterly)
