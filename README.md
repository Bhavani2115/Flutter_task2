# EZ Loans – Login · Sign up · Forgot password (Flutter)

One codebase for **Android, iOS and Web**.

## Run it

```bash
# 1) inside this folder, generate the platform folders (android/ ios/ web/ ...)
flutter create .

# 2) install packages
flutter pub get

# 3) run
flutter run -d chrome        # web
flutter run -d android       # Android device / emulator
flutter run -d ios           # iOS simulator (macOS only)
```

`flutter create .` never overwrites existing files, so `lib/`, `assets/` and
`pubspec.yaml` stay as they are. (If it adds its own `test/widget_test.dart`
that references `MyApp`, just keep the one provided here.)

Fonts come from the `google_fonts` package (Plus Jakarta Sans) and are
downloaded on first run, so the first launch needs internet.

## Structure

```
lib/
  main.dart
  core/        colors + text style, validators, routes, config, snackbar helper
  widgets/     background painter, header, form card, text field, gradient button,
               social buttons, floating chips/decor
  screens/     login_screen · signup_screen · forgot_password_screen
assets/images/ transparent PNGs cut from your logos / illustration
```

## What is implemented

* **Login** – logo, "Welcome back", email, password with eye toggle,
  "Forgot password?", full-width Login button, "Don't have an account? Sign up".
* **Sign up** – full name, email, phone, password, confirm password, terms
  checkbox, Sign Up button, "Already have an account? Log in".
* **Forgot password** – short text, one email field, "Send reset link",
  "Back to Login" (+ success message after the fake request).
* **Validation (red message under the field)** – empty fields, invalid email,
  phone format, password < 6 chars, passwords do not match, terms not ticked.
  Errors appear after the first tap on the button, then update live while typing.
* **Bonus** – "Continue with Google" / "Continue with Apple" (design only) and a
  2-second loading spinner on the Login / Sign Up / Send reset link buttons.

## Tweaks

* Hide the social buttons: `kShowSocialButtons = false` in `lib/core/app_config.dart`.
* Spinner duration: `kFakeNetworkDelay` in the same file.
* Replace the fake delay in each screen's `_login / _signUp / _send` with your real API call.

## Layout notes (v2)
* Text column is limited to the left ~47 % of the screen; the illustration is pushed right so text never touches the girl. Header text ignores system font scaling so it can't grow onto her.
* Android "stretch" overscroll removed (`lib/core/scroll_behavior.dart`, clamping physics). The background is fixed and does not resize when the keyboard opens.
* Requires Flutter 3.16 or newer.
