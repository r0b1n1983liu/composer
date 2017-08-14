ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1-unstable.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1-unstable.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data-unstable"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:unstable
docker tag hyperledger/composer-playground:unstable hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� j �Y �=�r۸����sfy*{N���aj0Lj�LFI��匧��(Y�.�n����P$ѢH/�����W��>������V� %S[�/Jf����4���h4@�P��
)F�4l25yضWo��=��� � ���h�c�1p�?a�,��l<�G�0l,�2O �@��
��� OK���x���Ї���.��)ʆV_U��KQ �<a����_�#�:��t�wǹ$S��m�����`���(?�R�4,��� �w�f�o��A��Z�ރ�3BJ�
���T>K���\v��g �q� �	[��9)Cס�NZFK� ��֒���?K(Ө6��	%�sP�k�i�K5qq�z�@�}6�̖s�_s�����a]�*�a�H����G��W,�D#�ʚ=���ADf&װ��B́��M偙� %\K�Ĵ-SٍD��ax!�Lb�v���3E��R>�Тtd4Q��Q�FI3�=�̥1f�j����,�"ϙ�k�;�c"�9l����g����2�ݽ�!Ǆ+��u������`�:����2��[,[Gt�9�nʽ��� C�$j��:��S�K�ZEJ�N�<� ?�}3Y��/:����+O��Z���4Ѥ�;�q�O���ވ������b�����|<.ܴ�c���a��<�O����́/|��3����1н*lw������g9�?��B������[<�.�P�HC�;�m����P��OS���C�?&���Y�T+��ẇ+�����s�D�"g�!��1�oZ~y0G����������6�����s�ߔ�.�·�mC�6�������"��?�rHDc���G7��Z o����Yf [,�wa&̄/uڷ5Z�B�l� ����<�p�z�8?@˰ж�5��nd�0]o�|LK���ѱ\H�d��֔S���T�6鑈��C��хC��k^��f(]�#�]����+���.�x����	u�mUԱ���ji���;Y��Z3$[JG�\��j&���`a��"8I=��@z��Հk�k4����$5ԾT�,6̏�H^z?'1�3*�J��7抺�(�/n�����&_�k.��8_�sL����Ρ5A���u@����l偖��8p:����em��ч(��uUo_��q!�1�/��u��=�$,L�~}I�-�[��,� ��4>��U�HA�c � ���Q���� |��"�a#��i�e�@�$5S-5�M6.[�nl��;9j~�f� �P�{�G13@#8j�+�d �b<b
��k�}�&�m1�^��V1���
2hƝ�d>�w`��y�8G"3oU�<��}�/i�V����6$_���>������ю6G������\�!�0�M�:4PuX��ч�ml�A����t�A,�3�)什��0'�����?���1�qc�Kʯh�U���W���qz����&���3z���D�^а��}��q��1�74�g��P?ڲB5n��/�������au�2�������l�#��s�@m,�������n����NJ_�_<���l����iS�c����v�����4ײpHk �ǰ�T:W޻�:�����Y%U�V���t�1��|ˮ���� _mc����DVnFL�s���T��J�WW�f�o�N  ��nC�Gd��n7�E� ��&��:�lxs��F��~>����;�Yz+U�\=��
R�V���	�y��xaC4YM��L&Jﱂ�lZpo���P�ë�$*�x�<������s��xKB��I�Ed��@w{h������,,.��dAG�t�V�d���舯�|g]��f�BOr��,bs���v���ȸ��+��l�������a��O���� .��=e�Ņ�F��/�Գ�Z}�t�TM���Pȴ`K� �uU<&�_�7Z��0G������z�g��1���u����;&�,�����?����������/���0��ᢂ�������Jxn�hn���eX?�Ru�� ���z�Sx����?�;;�P����/{��ٯ��7�s����QC����yFj�X�Lf�Ӎ�c��*e0A��d���Vm��hP�Q��K,�^����az��1٣�5�>�F��(�BV�=x�k��#��X䇹�O� ���_^���P��Y��n�?�����G����m�Ȟ�j2	@����^��H� �{���z�b/vbg1>Ą�03*��Z����w��,/�w�,�p��E�䟋o���*���n�j̣W�*����%1]�½��m,��ga��/D7�?��=�#�I�>t\s�ʇ�#V�KX^���YpQ�Gt�����/���V��y���8���u�#*�^� d�H����' �2��UɿF!��(��N���	��!vG5+�U;��ph�"k�v�w��+Bn�
"�z컍[p�#ܩ+d��/��[���4cx,�NU�N�E���"U�]�dQ&E]QhLGA���e�G#��6h@���s�MG�ȷ"]�_P��C�*��is{�6�,��?q6���� _!Y}_r3�/���;�B`k*����K��qL�s�.Z�
I�\)�Sg)�LD�IE1���{��' T�dn'k�y1䮩�@
K4e0��)\0%J4��<�C U*Kg��T>��T���j)-U�T��D�PO҇�\�������lE,W��(l�?�"�R6�+f��R]�便d-;�p.��Fd&�� w&��;Ą�fO�\��j���2�)U+�'�xB��ϣ�`���T����?�Ru�081{��k6�[S��x�'Xm̀v��mk�@x0� �hB�\2�御�=8�g���K��B������aA��|lZ�3������g��#v���#_ɝ�y�]��wTK�	B!rj���|����j�l�~t�l������%>�<���:��X�n��ۋ����x9�g��d���������<>,;���n���a����Fv������߻�������ų��J_�o		Q'z���-�#��a/�}���jl�N����������]#p[�ʧ��|
XV���R���?���y���-�����	��^�Qx�o�ZT@�WCW��_��Q�j���i6&��i�����\
�H�g�����������!Hn���c"����m��/!�hY��ϡ����������s��-p_�����"�Xs����j�4��;�� �M��8��R�b��5xc��b�v�+/��0fa���ܷ`>z����b���ue����x0�"�U����L�-2�ٔ�Q�"s�H�
��!��]B+>qs��6�g|H4�o���8}n���������C����8�y�e-���_+1O=���Em,���i�O���_���|M�Q����?|���_������֟~����<��i)���	��h��N"k5��eȳ���F"�+2�	���Ǝ l��W��~EMW����7�O�ij*�_�!��t�O���m�ɷ�)*e�a9����׭��F��u�������d5�o�������y;�����?�[��������R��[�z�2�i�����0��~�kX��O=�7���O,ܕ�X]�G���_�q����-������?/�7�-���cX�o5�&J�4h� ���0�i�����=�A�\��|KV �g:���H�j{�rd��
���``<�h1J|'��v����%�sQe��NSf������D���rB���&�qmi"U��k �NCR�� %���L.%V%��^/�r��y*%*��8�%�v�,ݒ^/�6#���xW��R�܁q��<g$�;P.�<�A�fE�&%;�T�^��.�r�]�����n���j�F�+K�s���)�t���{]�e�N�<�v.�U�aT�lbxz)��o;��ۤ}Z�s��e�P��b罞����w�b����9�P�1�j�;�i�$���׏ϓ�=H���GGYi�^���4p�w�d�������i_�	�IU:.$���_����qs����X8����R��d�8��X�X腊��l�Q�Z�W�7��S4��B69�5[)�	�-eS)��@����̺;�#6۽�Tu#ߏߪ'��K�q8.W�$��|���ʵ։| d�fEU�B�4~j�;�J<g����)/����y���D����H�����~;-�X�I��#��XHٸW���[H��d�:��x2�L�׭r�;8��j����R�bR�XA�����݂h�{�f0%2m� �R��o���)��k�z��2!'"��U<�`E?��~�i��� f�o�M#cH�,��Dܭ������2�S|"�okeq�NX^*��}uu��#����W�Ǌk���O�eX�n��-��l��=�G�gF��2�6�E��Q���_��/:}�o`M�`����eYas�s-��˹:Z��tBR�R�\v���mkt2�dlC�&7���I��F�)uZ�L�}��cM�k�4T.�G:�v�ɕŲ�O�G�b�,Ժ�9uY�{)�xՀ��_�ֆGea(d4(���\Vm�:�z�0�j������t����U�`��1
���x��ا��>����]������d����]����c��������Z ��ג�\*��g�ip��?R�������Q[�����2�\ͼ)\�݈��7mS>�E�RF)s�)t%���ӷn=SNtC4�&{p��^:�����������7�v5'����^p���S���� �C�1p`IKm���� ,��X��>�#D�����3�2̡E�'s���e���i���lP��/�a���<L����C�/��Bk�Z3!�Pmtɋ@*Ym�!��-UWIĔ��Q]��^��z�.��5~�9�m?0Iz�����7�u�@Q���@ ����� _E��m\#]1�Bf�!���(�Ԍ	AªF����B��F��7lG'�����3�Ks��ڂ�f�%�ſm�Q��T͹�၏;�VM�A�8��鐗��/	C]nhп�G;�� ��D�
��k��y�k�
P�'�]��?{W�ʑדl�NH"�}yaX�f�M������h��nw�n�۟���F��v��m���v�^=)\a�ja'.H8!� q@BB�!$���.PU�����f�<8�Q�����Wտ��Qտ��юG���0�(>`)�;��pp��f��`D��,P�(�˚h�	ys����lSCU���m��U貫oohI>�+�SN/��bk?���H>'M02��~Q��d�̌�36W�� �\䠜l��<t��/A�<M�Ǜ��?�г2l� ݓ�>wzG[g|�&�+?{��������/g$?�w%�nb	m~��C�΀>��M�!�j��m���T!���ɉb��@�)���ކv��n�~�0`�6t:E_�{0�̯Ӕ`�C�h
Q'�Ԑ��\�/
�,��[Ʒ�	�l��&��/�ϸxx��v���=�n@(�Cc���o��6�#����<����E-�c �j�j[�srE���ӑ���]ۘB�X�%��sS �!���c�����pt ��|$+s�1>"���m���S���Td��ɴk9���<������
��پm�[c��.N�)4*]}jB-���k�BJ��w��&ݹ��Tu�����:l�%e�-:d*(�.*��|~��]C�5����#��8��C��FG���Ʉ��Rhݪ�2����Wu����&��NM�-_�]�k#�Vt��I�Bodk�)xcsO5����k&ѷ����zh�@ү;���?�E��d�����W�!�v����>�V����?����s���������}b�_=|����!E�6E�&E,�_�y���w����~���gRh�g_�c�DF�JJ���D,���R/��e"�x����� ))���xFN�	������>��_O����O����٣�;������;}e�~+B|?��H�? �^!k���}���@���=����{w�������y�����V��1�j0�=�X�-J�~:�ܷ�b��$̳�Ͱ������Y�Z����D +�+_E V��:��Bm;���
�ူ�؎rSb;!���ȼ����Y{.���Y����V��� ̳K����"��B]�9�i<g��vk>�3i���z����Y��)6!��Gž4,����L�윍	��9�ߝ����v���|sڎf,�n�yӰ7/����7X�&5hW���}~yT\0C�t���&�IX�x��G��*��&;�M]��\�Xk����/s��A��3%_o&!a��=!�YT�z�J�
a��}���Ơ�"��@���C?h��1��7m�ϖ���jq�WkjX�y���B��"}·D����F<9��'Ƣ�z��y|���!�:ͫ���,�7�,�8U��y&�'��Z�����x֔�l{yT��Y>�w��$��M�N�Giz6��ben&G�X9����f#�Z���.{�{�6�~I�}I�|I�{I�zI�yI�xI�wI�vI�uI�tIl�\^�̻ě����&��_�(��}��p���g��%�,�;��-.������Y���В��%�|�]\��B�֮�@��v�'m`�=ܼ�
�s?��N��e59E��Tq�3��~�*�,-�i����B��x#�*D�$GͨpR��s"���d<��N���L�dBE��m�^�������y���to?Kg�@d�\y�<�DM=^� �liSݔ�'�X�vn_�~Jta�T(b��2I��j®�L��s�vK�h�D�*��� ��'�=c�raU�|��XK6;�ʤ[%�H��A�����!w����{��"��[�����G���[��7v^�}��rÿ`o7�s���e7��o��x�u6�e�<����u�OC��|#����}v���+����{���
����z#��_�˲�~��'�~�Q��$�B����?r��?x���<��?�֔��Д�`��y+=����T�֢̥�'I�׽����}~�����F7��k���rv�<�\�m�f:O�r������pLW��T�t�֦>��g�+��#�(-���:�Y9�alɬ�4�Q�1K*WHM��dq�W��Y��$����H��re�va_F����M�١�t�q޶�8m�{���0WT5~\<6��M��tű2i��[m�"�;mFms�;���`<��42�����cAf՚�d qˡ��aU����~�x?��@�8�h�`۹��o�|{����5G��4�p�Fk'�bP=�K��o��TDTNR��IFj$!�k�pд�BTA���Yc{T�ό�~\W�;�Q�ş��./��d�����⁽_�Vi�(P��@��.�y�9�	�R�K�*�:�ח����������/mȹ%}������#�k?aE.&��E��[�����0�w�X?�>>�J����wO�	��m�z0����>��o��rY�-�d��Z��5S�^-U���)N���65�r)�?hi��Xi-s6N0��bu���������W�QZ˞2�l���e�3��p�h�	�9'P�
4m9�r�dk6o�jk8�Z��y5W��T�7�O���GpN'tU"�4��c5�/
\u2���>-��Q�$]U�c�XhĦ<抍ԬH0�o�yG�
�z]�
��b<�/�{�lA�����52}jP�P����%�tqY{�B1�_]�e9��ʑ�ٰ6�h��@e���1�BTbK�u$���]G2�y�N�v	F��ؙ�]��	����t& N�<gRG��P����z��(�b��q�(;�7�z���đ�r�	���\֤{�hz֩5x5�-��1t:�h��	�*Q��l��|L_��3�H/��Qn�Pϣlq(�f�-������hi���#��g�B-��D�]vB@\(���w(L�_�i�R��DM�O��|ܢ;"}r��W�ِ��фB�}8�d�f0vcގL�P�&9�j�H��q}!v:�V�Qa�
w�2�ail�>}c��@\�n�`���E�7������c���w`u��s�Q��Л�Qӣ��e���Ӛh΋�ЎO�+�/�_edNMq1VB��"�4��I����e4��zz{�x��/��>��K�o��JZ�6z�x�y�qPD�ƓŇ�M�4��1��1�5�9��2~��>!�/ ���TZWH��ОpM��֧�/b�,������rN'X4;�?���<��9�,O�T�P"�K|��o��^��E^�tn��Tv�ל�����s��Od�o�şk��E���?ģѯ��������+��%p��wӤ��)�j���ϝ\C�y�ܙ�!)���͗�>$F��a���d�
��L�P��Ή��hW�3tT��n�ww�!A��&�i���;��Wצ�����w���'���0�*At�z^���R��4�u=�ŗ�Y^S�_���Y:��pK%�����"���[�V��uÁ����b	� �\ �?���a����(�� �s��~��L]��3A���`����1�7���q���m#�����.�51���$y�4��T�ɑ}jv��4���ԑ�4�<��_P�Wh5��2`	� �t��d�J|L��'X]T�`�2���Kt�lC���§��=P1�w������y����rn<�L��sER@��j���Y���6��49ׅ���w���m��������\�46���C8j���8X!�"tb��Ɣ��$�2(0�N�QW�����s�$��T��ٝȾܺ#�;����M�o"lo.z������}c��lX؏���z���aS�����"��+Nx��0M|ֳ
�hc|l�t��h>��Ŧb�4�Zc�"ZW�����p�Fb���p,��Fʡ̭5n���"rؼ�p�BR�3����pY���Wۀ��5.�oD�7�c����$��G&p��l]`�Һ[�&�������~��)���w���p�I�r��8�
"$���x�/0���Pπ�;�1`N���0�wo z��N�"��S�?�^�{٬۫.^� ݵ��`�P����dTO�`()=�Cm#
H	��|�.�d�\�VIP�5�&�nn������F)�k��W�1�5����bf�`���m@�ce2�MA��@��qs��B�K�%(�)���XfaA!;���/�+!*t½a;x�	D�^�h@�͒WU\U�`e��"`�n��4)0��Uq�6�lTo�?x��#i/|t���cƽRa�n��*T� �5&k�v����7v%�%�\�!=9��L�r�ºf�q�iH�y�8� V@Yݣ�� �rE��䫇�vh�_�M��6�4M��t��L$]Y���<74�h���N��%p���N(-�D�w1�n�-n�0R,ۘ\��)�t��~�ոp���g��'�f������ް�_�����]���2����HES����Qg���翾��q��F?%4���l�sñ����Ûܕ��3��F�����i�>EWc<+V7���;(�dlp�c����i�bKm���ʅ^����
_M[��?E'���k
:��/V�FeЋ%�R )��D��)�D/��u�J��S=
����g��ԓz�$���
�&��9p,�{���{����^���>��K~�Y'�%��T|iȍ[��C|�9<���XR %@��H<I�@��J� @2�(�H:�Vb@�� %��(�B�$P�`ȧ�s�!�;�ɧ�X3�����/<y���M[�v�{�٩�Qn�(���&[�o!�Fe��>x��V�,W��:ϕ�:]:-U�%�+=�i�^N�7D�L�l�k4�Ep|�����'*�3���v����/ٲvE��tIhTy�Y`��:jt�Յ*ͱ�څWV����TF�3acl�U����I7�jV*��t��ֵ�;�b���I�3s�2���}q�z�Z#{��;𖁈p��M	�ҷ/�l�W,�\>�/�z��V��y��?�r\}c����͗�vE�(�1��:�pʕ�j�/�Ϧ#m~��V��L����� �9Q�pH^������q�եͺ����Z�4�l����eNlU�Gl�3O�N��v�]�gM�"Lu�Wi�pQiP�}mYu��aކH���E��ܳ,��e���V��˸m�_���9m�پ�W�w�4���4$Bz9�	1O������ر㭝���)BLЖ�^ݻ{���=]��a��$���	�b��e'���W��6���?O�<����t9v�;�����M���S��_��]ӳ��7��G��:��s�V&�y��G����x��~=��m��g��ą��������~�7w���Y����.��G���i�?����_*/�K����?�������^7��b�M
�?���H����\����g�r����$i���G�߾�7���gh���G,��9�����o���?������� @��o���G�����������@������D����i���r�Kq4s�����`?�3`?�[�g�~�	X�?���/�H�J�ő䟣�QL��H#��,EF����8�CI�0�ER1!�	L �b�QL����~�����C���ԭ���_H���{>&����`��&���-�j���6��e���w-�=L��������q�l�7����B��[�LL7��GX�c���ɔ���1�ixgjc�ԇ�m��l���cH)���R��s�ǳ?��������������PR�����K�� ��8�?M���3��(���PX���� ��/��o��  ��@��)�.�|j �����p��������RY"� ��/��9���y�����>���*Qt@��?��di���)��A��	s:aN�]��.`���;��P���Ї�0@�������� �#F��� ����n�?)
�x)��/������Ճ�X�R6�K��K�n����
��Me���ٽ�~�����F�5�ͽ���O�m��y^}˪��m}�Om��̦)~�h�l���S�~TQs3.7˩�qY���i�:e��p��<�Ǚ\i��~�V���T�X{������q�����r��S�'�+}�U?�o�TOjt�����,������mc�:6���h�ް?��T��iy�N3e�뉙I�s�Ҥ���R�f�4
����%�Q�C���}�q��\]��~���!�m�:��=2�^���������� 
)�b ����X�?����\�P������ ����	�����������A�� �/�$P�_ ������7�������o����C���������9���������L�t�a�'m�]u����J������ǰ>������8�'^:�o�k�Z(�À>�<�:��L6Afo:�!h���]���y�[K�Bh�r�i(F�S�I�����Glk�l�5:�e��,SO�a=�}\˦�_�z��'@5e9o<��SE�sc%w�O<����9�m��;�k'�h0���O�3�^��*^�3s(l�Q�r� ��#O�V�����(�YE��S=�W2rb�F��=NZ�������������G��C��,>��jC�_  �����g��W�/8�G��?��8*
I��8�X�#9I
b2f1�PC�g|^i&I&�C�����I���������C�����?=5���0QV�r�l�D�J���$�Y*1��6���MT�G�[#g�g;�}��w=Γ�{T�;J]W���mg�C�އ��x�d� �
Z�&�D��f�l�U��	�T�ݲs0������?�����l��������C�Oa���>��sX�������!�+�3��Y���5��~�O��!v^g��k�wgͭ.��79'NW���Oo2|K�I�<|��uimի>s*��Q�LBU=x,9K�N�2�~��=�t��Jm�+u��"��4l�m]&l�x���?�߂������ۿ���	�������A��A��@���X���p��Β������Y�%�W��v�fUU���b 4�O�����?�����'��ʲ�g�5~� ���;f ��ٻ3 �R5����T��T���g ��~�b;nC.��يi�VKzFμ�h�*e�Qύfe9u�SUO!]J�N�)4��Ϊ���U��՛��JV�\L/̉ĳ��~��.>��^f �nE�M�l�D�(g�I��WhѾ\+'I;�����"uʶ�X9-��Ek�b�Vj�n#5����ǦRR+Ke����R�*��p;i �M�V�� �ݺR�]�*��QS&��H3�Kbŏ6��N���<Q��T��U�{T^�g��Yc����yrP,��?κ��f$��h�����;�������>Tx�����y[���<�� �O�w���	��?x�aT������@B������������?Q��_��?J���  Y�"?��I_�}��Y)H�c���4���H�bV�)��ch��0��ߩ��8�A��Y�뵂��d�]n�{]��&����A�rvlmz쉷Lves�c���т�:��G�9�Ss�4�����})����֓E��HZۭE���I�e犧��ήf�.-5�[Ub�Jw�"�E�_���3��?H����x(�[~����?OӐ�G,�����C�"��?ZL��G ����4}����?D@�������q0&@�����N��C���/翡����ڵ�=�t��J����>��7��ᩐ�oM���u�����F����r�M���;��v���}N�R�xċ��՝�8(6U����[5��5��)��ژ�w�u��l��=a�qGC�!7*~�L&�)x���5�r#5�v��X�XM�ƴ�U���V��Y����~Y�Z����[Yl='(�"�Ns�7��C�o���Z��	]�j���n����]հU6m�<���&�cV�Oח��W4���e��{�^�ʉ�8\�_-��1ZUV��׍ܔ��Czf�퓓��J�>�܎�uY62���j��4���
��?��Á�����-�C!8n�!��S������P���P���p�����_6O!�% ��������“��?B `�����9��Q ����������;��$�?����^~i��p(��-�?�?���4I����?
����e��-����������!
�?���O��� ���?�C�������3��?� /�s�@�����������?���]��.`�����/� �:C
���[�a���M��?"`���R p����?0����� ��� �p��� ����ϭ���8�/x�?�C������ �������������G$�@���������[�a�������ߑ +�����!����� ��P���t�.`���;�����Y|L��6�� @������<�`�:���u�|0"CAdHq$J�(d1�X������'�3O�>%
�P��K>�r¿�G��/p��� �/�����;G@��ЇO��v�8�E�J���Kn���4�fSi�&ei2x�k�=ҡ�U����yE��S�a/�ݸ#[�,w�{5�]��6�٩�B��c�|U
�`{3�hw�#W�ǜ۫��I���Kw��u[tL��\��ݱ�պd��s�2կ��͗*��c���,���N}�?�������?|�?�0���	��C�W~g���;��V7����5����X�M�ѩS=��
�>dGy�/�����2g�̭S�m���v;6��|�٣��$���7��@*Ʀ�wJ��TO���P�7퍩�[�.�9�4���YN�c�� �{-���o�C�0��C��p�7^�?8�A�Wq��/����/�����b�?�� ����������x���ZW������W=F��[~��t���>������n����.�NS<ūR�`v_���c�Mw;[w�rI�Ϥ�:��:H���l���Fa�i�j3��d'e����4��T>�2i3bR�:N�	�fOl����Ԭ�r�V����+}���.�z���݊����^�*�^Q��:y*�ċ�-ڗk�$i�Vu�S�@�Nٶ+�Eb�"aZ��J-�m����l�jԄC�n$�i*f"FF��=bqh����I�js�5�btC-���2�(�ͳR$��*Y�\)�m�Yy�\s������+�N�_m�x�|x��<��I���+���H���|��+�������G�?����	��H������J�����u�gI��G��&���_������'xz�T��S��y����<��P����UU9:~��0���^/agR�Ҍ�>cޜ�����?*��<������U^}ȸi�_�tV:'�:�ì�ה�ֹO)?�k�������7Ϟ�.}SI�R��K�򒹼���ږ��rWI��L��|ͺ���_
�����^�Pץ��;m�hs�y�K[�J�ֺ�ʣ>-�=�1Z?��kʟ˒3�ʜ�5)����7�2��O�4ޮ(1t����xM�]�o���8w~^�\I���gY��Oi?�����%�V6��=i�=QTEp���))�fy������N��r��JӘ>�ږ���Y�>�2'VM�]�(��9qD�J�:g��E���u��@:����`�4S+���2q˾�;�!��An*�!�O���5v~�z^ؗ��6o�o��	X�?������x��a$R,�K#&����,J#��I��B�e���r!��dHE���Q�!����?�?��C��Y����H�y��hO�y@�m����񧻸~�6g�"z�)�c���\�V�o�+�����G?������K���%0���H������@��/�����?����k�.�?�k����}��N���?Z����(����]���0�<��9w��]l��r�/�~�{r������Tܧ�_�)����#^����I��l�DUj�����YQl�~�W��*^�_^���# �y::2 �TE����p�f�L�ʬ��@�{Ed��(�}����R��=C\���#����❮��ڼQv\��p��N���z�Kqt\�lX5��+*�#��$�C�u��:���S5��:�Z;6�2?)3L�J�+[�S}.������3�D�����8�{3I�G��u'862f��u���(��z�H39k[�n|,��M�9ϰɍQ^��T^)$����N2c��q�+����{�?P��	2��)��Iݠ�U��U�Hg�t:yE1�aj��jU�b�=��*N*�S��Z����"���Ϗ�U���@��=����ؠ]_�H��co�k���4�GrX=���?Ҽ�p^��~_����V��_��~�S��o�c���@�_��n��/d���i�/��XH ��������2���LY����`7�?�C��	�4�ç�ڇ��s���o�[-�������?����a����C��u�3;���Xw;��D�0Ađ��H����Sg%�:�����&��˶��m�d%��3WȷN]]g���+W������X\k�;/}������TΫe:S�,u�k������ɢ�����i�����}cz�u�-#Z�wQ�)Z����U~�F��w�N[�Xxl��/�?
���6���˼ϊ����e��{lS[��#eKl��ܗ���kZ���-���;yb�Ҿ��&'�e�m���>��i11��t=/}A2�*���n���`�:�U�U�!�k���Ú�w�#aX���1��Զ��d����"�?���ߐ��	���u�������E�X�)?d���Z<"����d�����	����	��0������p($ �l�W������1��\�P�����-���� ����������A��E�Y�+������|�Ob�g�B�?s����!��I���  ��ϟ������o&ȋ��q��� ���?��M���������������?yg��?���"'d����!��� ������؝�_���y�?(
��?��+�Wn� �##���"$?"���H��2�?���?�������Z��/D������_!���sCA�|!rB!������a�?���?���?�;����2A��/t,H���?��+��w� �+��!�?/"����� ��������B�?��������[�0��������E��
~���������Ve����H����Y#R7եY�R��T\'i�4����H�aL��h�}�V?�E��
}�C�6x���$	�JMa~���k	l�kK�i'�d-�[���ױ��$,Vӱ�~ߢ�k��~�k�?G�C�T�oLM���'Vt��m���t����A����L��ݸ�K=vI|�F:��TH��U�JkO�=K"�8i�Uf���Y�ʛ'����X�W�����M���C����y���f}��"����"�?���<���OI�w+<.�������q��&��8�St�aH�4�qM7�iܱ�ͼ�3�H\�����5�ɺ��tGkWӃ� ۉ���F.��{$!�pr�T��a�g:�����x���H�N��^�V��S��Z
,�Ň�<�!��Z�����oNȳ���'=��o�B�A�Wn��/����/�����9������}��*8�,�E��g������+
D?����,OI������?q�����K�s"��p_[s��@n��`�z���d�ko�>�aTw��N{�1�NUm��jެ�T9�8-��xZ�1!f.�sy��I�fn���b�ިK����}�6�A��+����,yQg�t����m�]>k��X�|MV�Y�����s�B<����~�u�Y�.Er��� ���-(uֱ�R�|�+�''�Od���������.�f�P�n-������l�:r��	<"��S9�M��;�vuL��	�I�#M�]]��n㨲����^�����)/�u��r ${Y|�_���n�?*L��	�o�B�?s��������ˋ��'��������n�?�P��Y W�O���n��?����ߩ���L�;��Z<�xD ����������E�p��Y����L�����, ��������B�?���/�L���� s�����
����Cn(��򏹠�?}[��A�G&�b��9��P?��Q����㦧��f���o�?�Q��z,�_�?b��#-�@���w�\��~�Wj?���+jgmn|���^�~�������+N4l��3.6�=��J���q�Gjt���˚�w�.&k�F�q���i�:��f�/��qA�a՜�g��X��+����ֺ�k�/r��WՄ��p,j9�ؔ����0�*mw�lO��8��SV���l�_��:3���$�cם��Ș1�z�����Q���8֑frֶ���Xد�8js�a���8x���RHT�ۛ!�d�^?΀A!������߫E��n�G�����
��0������/a S"�������& �/���/���7�'a�''��>.�wS<$ �l�W��0���P ��s �5
�C�n�R�_��������t�l�;r<�:Q:֨=�P��������X������6�;9]��� y��C@������=��v�*�U����,~wؖ�y�pWS!���a[��'m�veb��.:�������XkB�~ ��� $-���A��V���Mٮ	>��e�P�VKېhOA�;fe[k�s�jZ��9*��i8V��;{P��JG�8$��˚9���X��>��fB��w���L�����x�-�����_������ �g���?Y#]�0�I��Z��Ʋ�i�IaMj8E��Uk��&�2�iR��1�Q�2Ē�߇o����Q����'��g����Y0C���Zk��32�����j2��Š��kјG��u��S���h�`�u?P� �:���z�A�5%ǶoUT�s8,�\u���<�)�s���r�@�L0̀�� ���V�h�~-�����g~ȵ�O�ʻE��!�����������"�I�wS<$����������fj�D�')�Đ:�&���x�N+;D��\�D��5�����ڍG;���:�l�=r��1�jN)ďNCaBͰʄ��]�:�y_i�bD]I�I��ho���oBsv�H⿯E1����/*����=r��u �������� �_P��_P��?��������(��/'|I�MS�g��_��}z�z&J���4�0�&��o��^j ����� ������
��F�����˼��eŌ���٫���EcR���|�!k���U&:��p�l��Uʵ�y��VS�CEk��E���r�ϭϟ�<$�y��ƍ�����Un�s��l��	���\��?�@�8O$׏Z�_�J^4֔� �zĺ��3���}��bD��y���Ul�Q�Y/f�Fw�O��\n|ط���ό9�8MX�ہ�0:����D:{���b̞6���1G�6����BH��G�P�E-�>�ӃМ��5����^�װ��`���oo�h����):~]�����D�}��IW(��,p��-�+%��@��һ�����O;����&�z��ATYn ��yQz�cG�_~�M���蘞�lMgc���_N�"��cB',���#q���.=}�}��.���t����U�36�S�\������I����[������-�|@�_���OI$>�y
�?�_���)��矠��x����Ts<TSCA�Q�NT�z%�	¨d�6�w�/*��M�ĸ����ЈJ�C�)P�Rd%}Fr��	=�'�.~�����e)�/�ᩮ����c�����x�����o?����?�Y��e�*9+���_���Ӈ�A�	)���eC�y{��1O'wSZnc�[߻�K��}�j�6�6(5N�l��e��#Q����'$9��t59�ּ4_X�턼���9�U�$|h���0��OIu8b��#�-tǣ_�{��'y{W3��A�ޖ~��ޱ�!��0��ݛ\݅$/_��]�9�C/��`O���_�ϛ�Ǘ��)�mKwb��b0
KH�srM�5"�?6ze�{D�^��u�߻���_���'w�.���݁�'���a��vDYz�n."-B؇)�]�����~���Y���N���_�����>==d?   �b����� � 