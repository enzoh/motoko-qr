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

echo
echo == Demo.
echo

echo 01234567
echo
dfx canister call demo encode '(variant{Version = 1}, variant{M}, variant{Numeric}, "01234567")'  | tr -d '(")' | sed 's/#/█/g'
echo
echo HELLO WORLD
echo
dfx canister call demo encode '(variant{Version = 1}, variant{Q}, variant{Alphanumeric}, "HELLO WORLD")'  | tr -d '(")' | sed 's/#/█/g'
