# A-totp

Get totp codes in Alfred in a secure way.

## Installation

`$ brew install oauthtool`

Then insert your totp codes into the macOS keychain `atotp.keychain` like so:

```
$ security -i
> create-keychain atotp.keychain
> set-keychain-settings atotp.keychain
> add-generic-password -a atotp -s "Name of service" -w "TOTP CODE" atotp.keychain
> # repeat above command as needed, crtl-c to quit.
```

Now download and install the worklow.

## Usage

In alfred just type `t` then start typing the name of your service. The TOTP code will be copied to clipboard by default and pasted to top most running app on option select.

## Finding your totp codes
On most websites you can login and see your totp code in the 2-factor setting page.

## Thanks

Thanks to https://www.aria.ai/blog/posts/storing-secrets-with-keychain.html for the code on how to list items from macOS keychain.