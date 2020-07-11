echo PATH = $PATH
echo vessel @ `which vessel`

echo
echo == Build.
echo

dfx start --background
dfx canister create --all
dfx build

echo
echo == Test.
echo

dfx canister install --all
dfx canister call test run
dfx canister call demo encode '(variant{Version = 1}, variant{M}, variant{Numeric}, "01234567")'
dfx canister call demo encode '(variant{Version = 1}, variant{Q}, variant{Alphanumeric}, "HELLO WORLD")'
