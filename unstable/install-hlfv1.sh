ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f || echo 'All removed'

# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh

# Start all Docker containers.
docker-compose -p composer -f docker-compose-playground.yml up -d

# Wait for playground to start
sleep 5

# Pull the latest Docker images from Docker Hub.
##docker-compose pull
##docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Start all Docker containers.
##docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
##sleep 10

# Create the channel on peer0.
##docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
##docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
##docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
##docker exec peer1 peer channel join -b mychannel.block

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

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� ��7Y �]Ys�:�g�
j^��xߺ��F���6�`��R�ٌ���c Ig�tB:��[�/�$!�:���Q����u|���`�_>H�&�W�&���;|Aq%i%Q�������Ӝ��dk;�վ�S{;�^.�Z�?�#�'��v��^N�z/��˟�	��xM��)����!�U�/o����;����G�"��	�P�wo{�{�h�\�Z��r�K���l��+�r��4MW�/��5��N�;�����q0Ew�~z-�=�h, ǡP��Oj�#��?����ʽ������]��]�<�l�%l���(M�Iظ�E����OS$����Q����O�7�g��
?G�?��xQ��$�X�����/5��������ؐ՚�}P��	���S�4]h�(�H��&��I����V���l5�M[�Ta&��~ʧ1�<�j���@.6�&h!�S�J�MJO��<�Mt��h�C����@O�{<e��t�����24H���ֶޗ�.��P�Ȗ(z9�����tj��
/=���ѿ)~i��^4]�~���cx��GaT��W
>J�wWǷ׉=��+�=.�<��R��R�@��nȒ�j�V��2�4x���2BYS����ޖr<k.�m�h�ͅ�j2�u{�&�*Z�C�f	��5ļe��7�@�9��aRf�[7"��
��򸝢0i#��=də=Rg�A���?<Qd�a.�9�ĝh��&�or���s#w�p�W%W�׃�(f<�H����>-�������7Me'��k~�N��"r����;i�<��"o�5�H�X��`a�}� ď�������E�I>�{o-�+����g��x�P����P�ȀS}U���ÛC����F�v#a����+6F�L��~�A�ڀv�,g%�U.܎Pޕ��e��(nugJ7s-j6:p����{B.rp��G�'3�;�A�_�� \�_�[ix⹰� ����"ב.�ˢ�N�rІobd��<�� �-��hӁ����H���Jy`2��E��#�ס��L�Il�@�0�"�l�Qs^?���߰����!���-���&���>d�b��F<g�x��r]�a���l���3����Ϧ���=�����������6����>���V�_^�qV�����#ü�ީ��.Yo	$��-����9ǉP�1�%�
��Q�N����٩pP��*�*Hv�Vp?�+3�>M�� ��,,LCѕ�&�,�`w�8b�N��(��K���s԰�D�/['RS�w�йY��f�Ǧ�{E��bn5o;�p��;P �{�-C���O�e虻l�S�r!<QuhM���ãr����)gF���Y ���@��O��8^���X{x�gB��Z���C]��;����6%�|�H�9��A�A�9lQ��Qt�f��LH��5>�8�hQ�y��k�_
r���M��X����sS��gr]K���m3�>�P�0Y����O�K�ߵ������IV���C��3���{��.�D��%���+�����\{����c/��x[��%�f�Oe���*�������O��$�^@�lqu�"���a��a���]sY��(?pQ2@1g=ҫ��.�!�W����P]�e������qG��V�4��e��,��h\�o����b��Z6�`۶�17�ij��ɗ޲���f�V_r̹�4p�N�#ڃ967�hk�� ����V��(A��f)�Ӱ��y/~i�f�O�_
>J��CT��T���_��W���K�f�O�������(�#�*���-�gz����C��!|��l����:�f��w�бY��{�Ǧ��|h ���N����p\�� ��I��!&��{SinM�	����0w�s��t��$��P�s��m6�7�y�ֻ� 
�4%
��<.&�R��;Y�c���'Zט#m�G��lp�H:����9:'�8���c� N��9`H΁ ҳm��-LC^���Νp�n��3Զ��$tpaA�ܠ�w�=Ο��={2hBU'���F�����z�_@�I���u���N�,�Ҳ��h�����j*8���1���Y��e�$d��9Ɋ�����O�K��3�Ȋ��������(���RP����_���=�f����>�r�G���Rp��_��q1��*�/�W�_������C�J=��HA���2p	�{�M:x�������Юoh�a8�zn��(°J",�8, �Ϣ4K��]E��~(C����!4�U�_� �Oe®ȯV+U���؜����=�i�m����?��)���H�	�S����;����^����=��n�c�Vi�ہ�8"��	�y� ���`�ʇ7y��)%�v�Y��n<��q�������D��_� ���<��?Tu�w9�P���/S
��'�j������A��˗����q���_>R�/m�X�8�!���R�;��`8�|�']����O��,�Ѕ��bD�b�cۤ��K�.F!�K�,f{X�������L8��2��VE���_���#�������?]D��� �D4L^L�ݠ�nci�x�s�X鮑&����V�p�e���+�au]��S��0"7�3�`��(�|�G�|F�T��Nc�[����&���k��3[��ލ���/m}��GP��W
~�%�������W>i�?Ⱦ4Z�B�(C���(A>��&����R�Z�W���������]���X��a���ǳ�>�Y@���g�ݏ��{P����]P�z�F��=tw��ρnX�΁���~�9�Ѓ��6��2q�p��N�}1/�.���G��&1]���&�����k��4�Gx,�3��gr�CMf=Q'���7G����Q[x+.�K����Dӭ3�YO>�#ܖ�Q�2��8��n�u_;ms.���k ��ݚ�r.k)ZV�y:E��ڔ�9��t��nw�cC��B�w{�C ����䶷�<����à�bM p"�r65�y{WW\����Vd���Fg9�,3�V�֟��A��߃ j�;%6�NГr�&{+~f��ni���p�5��!��x����/m�����_
~���+��o�����Vn�o�2�����l�'q	���������6���z��ps'���B�ó�ч���7���3C��o�<���� o�2|�z����k����&>q[��'�A@�H���PwSR������ؚ���ms�ѷl���D��!�5S9v-Mhҩl�$��ԺN�t-�\9N�j�x�<��o?�l�C�����}�@�,4GN�F��Y�ͻ�����2�g�d5���ן��v�^�=�K�^����w:��M!��#Z�������g�?�G��������Gh���+���O>�������Ϙ����?e��=���������G��_��W��������N�����0����rp��/��.��*�W�_*������?�����B�?[�����\���G�4�aUS�C�,�2��`���h��.��>J8d��T��>B�.�8�W���V(C���?:��xY�e���?@i��-'�}˜�1lv�C���s�`�����GڢEM^��c�9��v�u%���Qt/YS\��A@����X�%5�Zߺ�#j��������pF�ehr��Lo�W�(�M{h^��y/�؝�i1��$���}���{�|��8BPO�!P����iVh������ (�������P�����R�M#;���&��O��1��t�^���C�P�z�\#W�"�ا����4����\�+�ծj�t����M����`��?����?=}0��u����I|=���)������ֲI�ʭ�����Q���U�r}\����ꝟ���}��\���_V���W�rj�_O���ڕw�m��D��>��/9���[�⶿�k{��ӛ��µo�*�������yZ�.��au[좱��Q�����:��t�!�@t����\�~^,}���"ͮ��(�׊Jr�#��Q����8���G�v��}��]t�~O�u�(޼ZZ���-����`{��ӿ)���ųڋ��=��e҂H��m��7����3�u=p�^��|�imz�k����?�ʾ���~>c�%��rQi�a�������|�o�i������^O�,u�p��l��Be�`�=�ڽV{��D:9*B�GJ��O�����G���-��⶧n��z8e���e.R|Wo�&�U�+�7�H��hȊ��أ�*��o�t�?N6�b�����6���+Ó8[�[;���>[R��É~�dO,�m1��?�㬢���wm1�[��v���ll�i�Yob�֮w��H$uo�1u�H�F��m�]S%Q�HI]�8-H�^����E��h
�Om�>�h���l h��EP4��mҞCIi$����Y���0C�����w����O��LNg��M�D���"�����]:���Q��T*�{;�F�4��y���'!��m�O���tGF�L�4�n�`$���h2.��#"O�dlr�p�	�D.�Z��˲(���k���&*�U�pr�?�%=�
�H
 ��x�Ϊ:��GMUӚ*�Mȍ�֐%�|�02��:�߾�7��������ƓJ΍a
��_f[�vB���9T	\Bm0��Л�aVz�q�4�,P�5�}}R�O�+^�4/��G�o�RI�5t�r�5DSb>��l4��![4�h�pJN�F2�Ԅ����s
N�?pJ�NG/zЛS���:�:bG�7�"۫(rK*�j��n���:�sU'
R}�3���t�1��qf7�`q����o�~�x�q���s��wM�U����*xn�����?�y�0E�W9Eh�,a����oáh:�	�)�����2��B�!*ȇ���V��mB�M���Y�j�r/�
ZZ�+@�lSD�Ԗ����hr��<��p[O�k)"*vEirn3
��YfĹ{�ݭ��@!�=�'��~LQA���p���X��!�r!��n{�"Ӆq�J+�~�W��dt��3��\��|���h��������"�W.b~��#��u�N�K0+b�j�Q�VD�������R��^������������v������y��لy�?�K�1USu1U��`�.�o�S]�3tr�����]�W$V��$�������uK|{��{
��+�� Iʩ������>���g��ܑhQ�������}�������O9���Ha3��I����(H�"�V๪�[|2ޓ[xGP��&�
ߐ�<NG�������H���`�3��+�w���~�uKjgxO�	��v�[b��:^�
&���e��ߐ
�Q�o����x�U*����7���o��Ӣ³�ް�%�|��_�n��a�|WІ�x��@I��r�;C������It�w��������φ�%��y�ә�q�W�����+8W����E����N�n��{I�����]���rovJ��z[�ْ>R<�R��f�?�Qw��.�.;a��z&���;���W�'M��L�)�v�����v��E�O����p�����e7��$����Khc�1��f��a��"rYR���E�`�w-0a���7&�<̐N�Y��n�ki'A�����2��g����3���/O)��O�I�a�a���&M�|��&��eI��?�,+Ȱ/�� E�.�A�-��\KQP
5xN��8�&��S�S�dx7}�-�M�0����p�"ْ$��}��1�WQ��2~����wg��T8����o]GE��p�`� T�%���Ϊj��2�l@�.�\�'#��t ^����&L��\�<�	�,�*o*M'ӷ��*�z�lV�	�����*��NUa"��1�ZQ�W�ms���e�+�%��M��̌o|	�����[���z�_����,.�E^��o\!��+2��dAE7���Y-qq�V���lI,�\dyp����N�����.��0���",��N����Q�����a���f��EX��O�(�����0�?�͎�uP��/g&�?.�~4
��U�yE����"@�e���-�F�M�}��g<l[�駪-���l��AѪ��7�JUËF!��T�-��9T��I�w�C2Ec�>	Gr�I�����,
/����7��h��FR�є���T�O$��-�!��؊���j�lG34C�A�#g1{����>�jQ$���ǈw��G�r�[\�T�sN�/+�'Y^$�Ni���k ����g>��h�G�)}OO����A]z��1��XAX���Q�P!�α:<����R��JU����[�>���I������l�u≭>�k(���RFuT\�;8'�tJJ�������?����S��]6��{&���������3n���\�5a?��h���H&H�O�\4��w��4����b��kP�����"���v�7���F�@y�9�+,�W_�t�`��x}/��E�]��)2",�2>����i��C�:��D�lK�����0sԂc�ZX���Y<�xx�"L4 ��N�P�4�'1�61�vYO��jN�XXxb��C��ڲnm����o��1�X����$���?�$���セd��?w�')tٷ��v��aG���t���g���Ȯ=r���w��k���	����Y$�P������6K���rQ���`yj�u؋�rY���a�\g�(F��E�wa>�}��S�_��=WN��#w�.���~��W����"�8����#�_X��Ãp�?�`?z��sq��_��'/�O���^�~���/L|��G\j��j^/��u�Ǎ��F����<��q7\�CwBU.Ƥ�Sw�t�C�x��*��jtv�~"���������qx>:;���iOĝjÂmWmNPnx�{����Z���X���zYk��MH�se��N1�OpY-������٫��I��)�۠�g�\?C�S�L�3�g���{��D����/���L���=��?�Ͱ�V{t�\���3ek�㮪|7ɤ�[O$�I�K��g�f� �Z![�f�{�p���U|�d��m�����-��PKg:�J���T��v�R%\��{�&P������jV�e3>~��(�Mk���}�g��G]�}�y�y�y�27aa�Z��EB�ȑ�����!l�f��+�+�J��'`���j�� �N��Y�+��B3$i�8ʴ-�N�Ţ��.�ZT�v�(�p57���������
�Z["����t��gbb 	�j�H�[�$�,�Z��b>-�bݒ��Y�����X��ҭ��5У��;9�GX��ڢ
Mo��r�h0��u�[P��A3�h&�R�����6WN6b�S�E�^9+�R	����.w"迿��?%fI/�,;djc��T�|Թ�)�{.2V��D�_!2厗ʹ��g<-o��R����ݹ]�ڈx��H�Ɩ$g0�Wh�ʠQ���,tBd2jN�v�"�8:%��S�r�x�v.��;�s�T��x�6f�,+o�n���
���m0U�Й��/����&���%
.b��(d:�r�t�c�.Wnz���e��,f��`����R[�YBT��'"�S�2T @�XP�E�=����x��W{Ŭ�au5�</�پ��V�t3��w���X�T(��:�O�~",֩�c�j���1��J�.� �&vm�T�KS�r�x�v.�$|VG���;;�"t�J^�X�N/�tr.��e��=G:F2{�+ �o�Ee��wՆ�i^1�gk�~5��W�B���H{<ת'�b����:���-��]<G�S�T�*��+*�
�����El;�?���ŧ�O�O��Hv0|®a8���X�u��8��g���V�������ո*:�Nni�3���1�ak����)�x�N��E��a�bπ�i��-���_�z6�$�j�������XVOz�^R[j���u�xT�E� ��'�Ҥ�>�};���y�;ąw���jZ�ƹ�=��)�~�?b�\O{�a7ÊBI/9�Y�IH���c��f�_�ӌzq^:�w���t�	�b��{W��cȰ���}�H@���
:<[�,� �c��}����3��k.�A�������u�'����gN
�I�ғ�w�!4ts��Н`���YK���ǻ�����N� eu��y*LB� �`��;;���?���Gy=L$AT6[�C���O���'1�Ll����B䳎��Պc��2;���Oؠio�#ùǞ���b|dI����19�K��0��w�A��Y�XE�W4F���1^�1��w��E�0!1>�oؙ����G6�z7p(v6�tYq�M%���܎���^)J�|Dt}��v�sTb�J;Gx����g�Tn�5&�ryg-���ڮ��o <����A([�G=�$z���1� C�Cv'2o��	��V<����h*��w�m5)�w3	a/���[	w���3��#L�6P���}�Ԥ�2���d�q�t��:���F��S�Tk��F:�G�*;��d
r�F֭6�[T���?-��p\�\'�G
��S8L�X��������A��c��y���#�i����]Ş��ύEx;oD8�yG�P�"����Z��7�ְ�3ѰLK�'ǒ�� �3�����'
uZ��P��`{�)B�|�Ƒ��b�{sQ�F�`y�=a�D�q�"�R��Qd�Xc��ú1�-LCJ�sWw��Ѫ/�{�`|�&�ڮ�)�m�H���-��٭fB[�]�B���}j���hYn���^��&�"	W���1�-�j9��x��b�
��6�6�൐}����HľG�l�l[#(�٥j�4����vr��F+�H�[v��%:�˞l��YӉ�C.k"LiG�v����/Tc;"mݳj��j����[�8mj�@�>�S84�XI�!'-~K)e��J�D�%L_K��0�]���f;��!V�
R%�)-Nk)��p��`xz�|}hѤK%�WU^���4xr�}� �և��bE�U�60[�R!�t8O� �T��<eGEE���(�����nó�_���v��=�����������K�������/`O�BEb��:x���nf�+�μ���<�R�C��N�<��l�\Ŀ����[L����ӿ�%��oF�}��������?
���G�?��oF��E�<��0�����}Eϣ]W�u�B	��]�q�����~���g޲�����?�����o`?��#�?G�s����hҵ�k���i�v�n�����i��~�WqM��i�6];M�Nӵ���L����ڹ�����^[��r7P��E��I_���U�s�BGO�1��쭧�:jc�9����1ׄ�1���T�L?s)�\J5�L�0����G�^g��`(_�m���i�{fLk��g��`n0�̘�a
��9�~�cl�9��9�N���imY��{�<���]is�H��S��k"*�)[���71B @�`pG�C+;I ��淏$���gI=����8�R�\Nޛ�ɟ���g�/=d�@��H<�^�y���no��D��$�習8E���Q (�5�O���AAh�s�R��܇G��k��T����r`[��@���y��{Qk�{�Wd�Ǚ8�᩻���a;�ϸ�I����	�v���)��2���[1�ԭr�Wt��e�_�u�թ���0�zn�[�f�d������9:��*�)�2jR�����:������"K�$�"��"&B,J�$I)O�(P�V~�μ�1� ��x11������̵^|e:؄�A��{����[��{w �S��~�ג��Â�#}������T�7�?y�nU�X�O9�,ֹ�SIj4�2'u����܅�^��nHYl�+�lߋ��Jj�A���*��_��s%߼������$���`���]��>�Yj<�y�)��wUK߈Y�Kmߔ,����ܱ�O�E�B�|֑i������ͧ�+�&�5~���G)����y�bx��*6v�_�z�=���'}`ߧ`k��=k��}ر5�益58�Bs;)���`��M�K$���󦽯�'�N�b��)a<���'����$�k��l�͗�!��7�v~ӫ��W����2_�'�#򭦸?R�,�Ӹe�������ip[�یP�H���t���a�o9.�Tl�^Lw�ѝs���;��_o�����N/�����m�<O<�w��;t!��W�Y)W�����|��\�ѐ�O�z�$r~k{�=���-I���?��K�^�J��{�׉�4��EO�	8h�/���ހ�޸��xN�)�'<s��!��GB��xly�������4qR���ҍ�Ӎ���G��0O���Jjj�ͤ'���!N�ug�_7������d@8;{���'��o���4��:䷅�C�^����c�<醩,��_�S�Řy��ׂ��]RaՈs&DO�����q��ޟ6�N�o[�=G�g0�_q�4tcfLu�ɷ�_�`E��}�M���lz�C˦��1�����Wot
��stJ��)��@��_��}��N�{`&"\=�wZ<J���?=��Cb8�)
���?o�Ҹ����HP�Qৗ����Ӹ��Q�A�G��+�m��q}��~ ���;�JִWLߑq�4���²~�AI��. (J!��R�/z���߶,��x�]�7�W��S�<�o�Q��'��w6�G�D�?���?
�?
D��#c���m�� ) ��?n��h���I��Q &��Z�T\C0]�qJ�4BAi�Fi�UIB�u�E(�@H�@�"LST�"5E�xr���~3D�����E�D���F��]S"/4��n�_�(vw{����DQ�k����6�rm~�5�����څ1�.�L����o[G[`�`ˏժ	�'>���>\�F��6��QtREd"�:i�n�ָ����2����UK�Zvv(Dw�nH���D*3.%K�Ӗ!�k?�����5���"	�?Jc��?��(m�.]�s\�'�������C��?���G����lkU�9�=� �%p��i��E��T3�j�%Ռ�[f4H��������/
Dk����?I ��������za�'��q��I8������?	��(��/�i��g}�rO'{^��*�站�$�*���'á�F�<+�l}��uh�Z��k��W��rv�^7��4��2P�j�a��v���l9t6]��r��^�WY�(�?����/�j��#wrWke3���}~^�8���.f��'Y\+>l�N��Lu�Jf�^����Uo�jm�6 �3˒��e����9�W�6����7Tfӆ$w�GkO�4���Qk4�.��d^ʱk#O��.0���2��J��l�0�EfހTJ|��=����/���.�`�'Dk�i
�����o�/	���g�H� ���0��$���������0��}��`��������?q �������@�#6D��@�#i ��?n���!&�'�6q�ݤ����8E���!hJ1	�EL�LcU
�SCI��
��:���IH��/���W��Ū�Z?�jY���:5V�S��w�F����F���B�7���Rs�-�]sH�s�,߮�Kƛ�ӂ���-��|ad���`rx����.��Fب9BS|�eV�[,��Iuf��ZL%e���E��������G� �����'����G|�����D �X�#���������������I���������!.�?	c �!�?��������P���P"������8��������'����P�ZB���Z��E��53=m�iR�9�L�+��@����Y?]dG��HosEx��6Z�ԄT��9I�݇:��zu�`���7�z�ٚ����Yc��o��:�����ha�<W	����b�qg.P$	��q���^7ej�|pI�ͭ`��qgo�d� p�/tgj�詽>��_���yV"���4δ
|iT��θ�_T�^Y�L���$��KMeΏ���z��=�Z���Y�j��2��Z�Ӫ�x)_j�mA�Hq&N�^G�t��su.��x�!u6g�Va�����H���?�C����H������$�?�����?��O
������ ����?�����_����w��1�����`���������G��	���`�G`�������O�����"���_���B���h��`�I�J0�f(&j��j�fj8�0,���0*��i�(͒$� ��/G����wI�#�_�B����*"?���rWxl��S��QW��J��oj�MU�«�(�4Ԟg�ҴlSͬ֙,��2������M<����ڲ�U[�U���L8$ǳf��=�~Go�%{�j5���_l����K
x�������H����U����q�OP�Q 	�?J^���������3X�PDQ���?��� �=��4�Ǆ���(p��  ��7�cȅ�@�#����8��������g�?@�3"$��Y�Y�a1�d1UURc��P�]#XSt��i��5M3qg	�4UCa�@�D�g�_7���?X�	���� u�qm�]��d^�Q�V�X��	�X+/��䊋�Q�s_����hB���t]�gT�^�����m�.1bf4�����'���H���ֻ#�-�E5�B�e9�xM(�u�֚aJk����六��C���48�)����� b���w����I�����G��n�� �%ȗ��|�����_�`�����չ҆�K�Y�2��]�k��9i+h=J�!l��b	����UЉ���5��&����\{����扽��*w�M�cm�^C۝U����Uy�mdA��XY�*~��[�C�&�+~��	u�7n7��ۭl��̈́��j�8a��dܗ�]/˅��6�D�>-��Iy�a�%t�j��W۾�ؒ3R�G�J.�y1��~k[�	�-Y/7��gy3�Kt�.�����Dx�d�4á<����nK�;땝z�Z�Kq��R|u�����`�v<V�6tW$�c���in5"�c�HN�n���"�=/���gN��w���mܦR��2?�A᮲^m��3��Td�J��)�Va,�*����t��!�eu�q<{�W��!��@d�2"7�(Ԉ�UZ����B]��G�˨S�����4E�eqR�Xs&��<�d�m��j���du��^M��t�a���r.��~��a��������������_"�����#FB���U0���������i�_���]/��U�]��d+�9���t�������壱�dl ��|T����a��Q(/p���������y�с�沿Ik6�][�%�WDn��9Ug��r��"W�6QTV���3����0T��!3s�|������9u�d�1}�5ʳ�{�A@/���y[w���?u�9��V�����]�����V�2�[#'7���\oHO��j�8T��T"�n=��Uh��r9�h�����damo:�����H���\���F�X�?pD� �����������@�+$����lH����c����`�����5��@\o��$J �?
$��G��`�'"D���u�`DQ����8E�? ���������?� �Ņ�B'��0�D)F�H���`0�DgL��iGp%T�d���4SU��)_�(��������쿯���\hgi�Yڃ��K�!z큮�e����7��T�U��fk2���\4�J�UV]��T�J��I���
.u}#*�̠�&�b�k�*��toH��Y�le����FYlPE=���Y|��ۆ�����e�Ɲ��H����E���O"h���$��?au0�U��CЯ)q5pS�4el�M�mٿ�f�`ꦔ�8��e�;w�c��[c	A�$uk������]D�7L-�ngۊ��E?��7�ۑ���*��=H}[�RJj����R�GA��>�S���%	i����?Rb%�����󕻡cM�?���w=3n�S7a��߷���m��?��n��&����3��ǖ��������ܤ���k�M	뺳�Q�}2��J'i��8|
#��|a8n�^�y%��+n1�����C�?�|�Ե�2G��_[�ʸԗ����#_��?_Ԥ}�i}�/�qq�����6qf�\	L�Q݇��ll����L�4p�_L���8����?!�jA�ַR7y���cC��5wO��z��+NJ5�鮖�)ӲSn�Hߕ�7�D��`�S�T3n���� ��N-��2����Q��pE0��D���K�W����'q��};�|��>Q�[�/�?��{�y����O`(��@�ܸ~~;5\ϲG~�����k^룃^1��Cww�r3U�����0�/��޳�Hr];~�kc{\V�zەQ�ݳ3�����eW�{�5��WKuuuuuWW�ԣ_�H�(R�x( �?��HćE��"� ?��l)"E��#$�#po���13=��ڂ��j���=��s�9��sO�[�5;����;=Ɒ?ez�y����g�� ��V�[���jUD�*��	�>�N>纂�[�G�T������y�^G�ƅ|/�7��G7�X�����|��ߛ�5��/�xۻ�v�]�h��v8��E�A���R�@3�nC+	�� &� ��A� �b�cp����������~�v�w}�o�ޯ���?�<��,�N9�t�Y��6�'��B�p���b��}��?z	�8�}�%��_B�������E�(ݍ��2�/j���mva3ٵ�͍F���/Α�t�.��(�͌��ި ?�Ӟ��Ϻdݾ>��ɹU����g~�F*C@�n�B��h� V܎�Mܗ)4|u�]�ӱq%����zJ�k��%����u"{�G�H�L�k����&�����T��n�l�y�{&O�E�Y�4t�%���S���8Ag#��|O�"����|T?>3*�i/�E�9����+��d<����Yo��5\�Ze�\��[ȴ���[L�R�ق�w$Ib��jqf7�J��v��Y2��G�-��x�Y	wV��UV��o\ha�qha��Z��4QΓ��f�TM�o��HeB�	��8�!��e,�^;N�1���enPM��(��Io��[)�M%��l�ݜ������������JX�ؼ���?٩$�՞/Q+�I�(�.gY���Z*��>^�(R�+�
L_��s�3��aE,+������?��;$�.%e��Ĳ�CK%���T��pr��$2��e����L`:���~!��7�zL���J��u�p��J|�x@�R]AX�|���$�&G��1-eEd:	�
=/�jS���G1�a�D�D-�ƦM�ƭx-9�:�l���v�TK����������	Y��5��Ϧ��~����P�FV~AX�g`��� �ñ��&c���:%�ȑ�USi�H���Ih�2������#�R�����A�Ԩ����/�)t�t{#�WX2˄e�DX��KwaI�3#��%Ƚ]�'��0���lgB�S_�U�r��Y����0Y�ʑ])A҇���R��m*ף�����{�"|��D���I���݆���Ҿ�\i�%bAX�g`��R|NCf�GI�8�I,�M���a��Ũ{�|��,Rb�{�t��r_��_������;T#EL
�@�P���M�gs|6�g[�g�x���m˛~�ɺ�)�$�n���G�t}�}t�cϠ��O��BĸCo������:�����#���պTU�E>���DUA�C�D��}�yy&��8Q�y���ϣ�!ϒ4�����/#����B����Vtet�V��1��dU�N��>�<&��h�l"Oi�T�)�~������ַ��o��Y�ܴ�s}f��(b�^Ԃ��<�E�W�x��Q�~
} ?eu���6�x`�1{�,<�n ��� �B���wQX�°�� tG����2��^G�q��9l��������ˏ������~�ϙ8���'o_8t������B26�VZ�H=ۭ	��^`������7��1��[�7KT�AC�t,��<8DV�p�hn�1��@���I�yv�l
�uF�{��(0�D?���pu���{��dP
P�A$E�Ci7�:ܓ��4&�t�H!�xw����l!���JG58��n�(�G���4�ʓM��>@;t�}D�Lp>N��lޓFo�ʓ̓ڐ=ʚ��$2��#RQci_0WIO�#moW(L#�w�,�2j)���Z���P�i�iP�;"I%��{io�ەC�Zo{:��S��ˌ��:�^2KH5��n��H����F�*�"`\���Q9���*Ǧ��r8�q��=��^A?��Oٜ�k�2{	�gZ�ayv.�E ������5����kzX�=,���^5���������xXN$��N$m�A�b�P��D�H4z�DK�n$HM"����3Vyr�U��zP��	��1�A�*D��ɲi��>f�n��CJRP�t�ǹN<�'�Tq�$:ʾLK�w�(%����wj�7a�\c0L⽸��TR���d2����>Od3l"]�C�c!�e�!���X}ج�Hu8�#l������Ӹ��fD�[�������ve6:�/ņ��q;���"#F�iʋWK";���x	"�֞X7�}�)�)��$~�E��T��ݣ��PI/�=J��n�����(���ߔ�Rޏo6ⷒS滴S6Sb���J!��l����]�R�4%w8��(�J+��E��\���׍�&�jI�,32�ڳ��F6�WK���o �R�gEЄNE�5�J��C: �W^Y��B�@<�>�~�rso!Vf������	�y�"���z��o��g�y��?�>�w�4V��~��n�5{]!�S����C�=M�!��qa��>�;�8���B67�o~���^~�����_�"�ܵ�rϿ�����_���$���c��启���!a䅵G��_�+-W�L�;'p-t����/<��;�|��w�'n3�_� ������|�Ay?��c�'[j�w6�fS;��v:��Nj��&�	8���*�G}�	H;i'��I�tR;����>
���η|���7/�T�Jh�����\��gd���B͂ 1��[pb��c���?����-5�]��3p�:'��YJu�R�<G9������#y������`9_��>�9��r��q���73�g�g�73�r8��������W��a|�s�A��.Z[5m�<� �9T~�Š5�c�?���_W��슜p����BJ�������C'��a\�M���8�d����zmWzr@����f�р�0�<^�6�W�[w ���b}j�	���2pp2�m|ό�	�8A;ց������M���82p�M�����նb�@!��w�h4�P�Qbq^��\&�(T� �F��f���rhls�Q�I��S#L�0���N!�#`����d���(��hZ\4j���L�@�� �c��m�,S�Ģd%SفH�j�xP��d�L��D+��X��T3���������;��a�80@29�I�����03$������&�*�2+@��#�9��lA4<�����v��pq�����\w�g@g+��5��v��. �݀�l{��ڲ�M[��iP��u�>����6A�p�Mϔ�MX"(f��L( (M\6�,���K@[c�>��d�����9�yp�Q��-;Q:p����Z-���z���>ךy"�P��Oz�D;<4��¶1�ܑfO6@���x�w�Ȳ:u,��'n�}8�H�V5��H��0��S9�T���yl�cO.��]
/ε����/3 !���:�-��@��j�b�N�I`d�P�<������p/���ج^�8*
�-h��%M�hY����7, ħ)�v�
l�	� �*�� }pk�˨��$[��VNU`?4��:�
�@�Xf��]���f�}�6�$���I	�`EX�_{.ɓ�޿�/��.0'������mU�y�K�nPtk	#�|x���v�(�׭�4����8l�ys�͖�&@�8n��b��@B���h�l:�}�`/�����P!����	C�A�w��R	���Y婲(*�n�`�X�À�OS��(��L�� ��miA�Lz���{Z5<��VTm�A�m�Sn�|ˣ�`�%�d��;�eP�;�9�2g�x�4L����7���5`���&���4Y�o�H�-��[pl��
��}ݥ;������uo��̓-��:��Ms����	;[K|t�a�~O	�\�as��C�i�g�(O�O���#(����ښ�', �{80��m0�E���ݻ�w�,�(��벒h��: �]��i�p��砲���2���rgQ:�v�φ��\��Y˅Ӽ���~I�}�&�_�.҄S�W��ur�ۭ�o���"�9=�_3�eu��_&?����:�k�>XiC!�#δ)�W���`*��>%
�m��ќ6�������zu�]�� ��
���:�,�I�[�����گcف����"�,���gTT:Nm��M0F�D�������0��r�Qgs 5�9m3G˵+��y$�é�ͦ��D	2����[C�cU6W����E�1D�y��6�8Ӻ����R����gV��v���;c�f����IR�O�ޘ���2�Kx��m��op���?���6�_�8Ii�-���*[F0�Z%/i�> cR[�����g�+c	���cE� �&@��t];��v��Á�x���v�v�Xy �1�xۤ��6*��K�ųU� �ϚW�Y�t����������G|A��W���"jG��� v�q���\�4Gԙs�e�q�|�>U�1}E����>���<�>���w&�s|0�-���a�h��֦��L�{9�&��1�ja�3��B�w6J�B����7-�}����r�N��'��^&�{�=�T�@&N�P@){�U?<7FƴG�![��@�(L!̰k_l�����`z�I�>��n:��y�m��o8����.Fh����w�.��ׅ��x�Fbh0��h��iN��:93���,[�QA��8�j���P�3�M[`@))�����Rl�<�A^R�6�� |�$Za� ��80v�#�?�e�isԂsmn��A�x Td��$fr&���<C�I�=bl�r;#����J���N��o)B�ʐޖ>���4Ӕn���f�:Ԑяn6&�-p;N�*���PFB��ҵ�7U��q�X�h���4�~@#��ͺ�5���&�Ð�G}©��6t�����y��A\[C9Eh;?[,��vPM3�y�Q���������K�S�10x��92��Z���o���/펌.�.)qbv"t;8er�*�s��/ =U!S��Z��`L �&�`8l���[/��`�r���-�a�YZc~S�"=7q�1
 `6\'(z@ޙ��p؜B����� 	_�f<Ֆ�f�AR���l�b@k+�-N������u,��{���ƕ5X(���ZJ�Y��la�������%� ˺�_���7q�M���+д�M�f:��6d����	Y�V�����߷�l�9ҝ�;ƣ�3��QU����z��	ߋ����C��~��'��@�C1�JF#?��`���r��ǿ��@M8�Ht��������|(��@��}(υQ �u.�M?1d��>���Ƅ�t�+o��$���_��%ߦu�����Om� 3�eZ�pX��\�L t^S�C��K�������� ���s�h�I����ԩ�w|��wK����U��Q��/�,TЌ���+���U�ݴ�X�{8����-S<��y���w��;/44���P�8^ wx&ͫ��m�U'�ġ����ﷺ�>C��7�>�L{����+���u���y�r%���9<�R�\�A�^Z�m�R��;�K�d���o5u�����2�6��>��]Z���:� 'C����l �(7�_/�_�� ��a������lx&Z��&C4��g��9�4��N�C�>��z�ֈ�}l2T	`�]7�;m^ez"*���̐����6���y?/�^gj��I�r�S�~�`=���G8�����W��W�%<��)�:-ۉL���� ��1w�8��#��c�;���'ȭ��;՚�&���8�d��,�b�_����b�?Ы�0C��̱*��hH7<ɰ�v��F�`��hdS7U}�ͤ���5�S��ȍ�s	�����>��w��R6��Hͥ�g�����R�b{�Z?X���<0�.i�lu}�5�<x"L۵�<�P����������w�������y� �o��kP9��	��/t��y��S�Gu������|�Ԇ�h�_��N��ơk�=9*��h*X��4?�;�NQj���K:�kS�{�|-�=�?�#�U?��/��jͧ&TC�oSg	�UO���)=�����J8C{=5�|8?�~z#4���W_�z�04v�(R��~;��md�Fy������_W�ߗ�߯��E���+ͫs�h(G�z��J�wx��� h``23����6��=�����zHC���$�G�Ta-?|��Q�G]O�Z�F�w���
��IVާ���.��I�9&��zαxy�I�<�*Ta�0���'��Gٰ���Z�A1�=f�UN��]�P�Lvuǘ �Ꮰ��T�W�U|������!�l�N�qV�̤�;�,�$�3õv��Vr����2y�%Ih�:ؕ���?�/w���k��}���q�H%���+YQ����֤z���� Z�� �m
k��8�m��1a��dJs:Җ�ro�à�N)�� �Ǔ��Kj�;���E����w��v	��.�~ITB��l�Ȇ|���^'��|� ����ĕ�4�[�0Y{���״$OVx��s�+���2I���>RYhZ���}�?�`�c������S�� �Jb���1Dh��i�|	�:��P�;�m˰�xL	ʁ��F���1����z��@��+�@���
�g��YZ�"�=���x�3\)*�^���'�}Km���&��:��Kp�'Y��W��^���@�sf�rf8�xf��h<3���>3���G�����K�pg�D�6�`w��}븺ɫ9PG��rbuܿ�L�J�u���4����P?���Bƣ��7N;�a\���桀g�>��W�{�FM�B�x�I�K3�;��;�`�>Q��w�����|�����8V�%N��eD���C�+�j�khf� .�¹*��5��g�(�5�jB��t��!��s������.�=�|�F�p�������јAM���>J�d�W�	�{$���R�#km]� 2;\M����? $��'F��܄`�6�3�_]���|5�TB�Nm|U�d�@r���S�YƱ�ǂ������g��$�l�tud�K�ϊ7?����K����pUz�k(E���#�]��1��N9)��ڱ>{���e�F�p|<�r�.�	�8@����'B�LB�n�>��Uh���PB�Z�m@�I���<�k�O�� �36>�����Ra5(!�5����/��=C��>����z�c�Ew������4�.N����?4�E3��5�Y��K��kN��j�𷾲�o���)�����"���Y��?���g(��H���h���_�ۧ���t�_*�y�����9��Q���`2�x{��$E������>�|O�3C�������W�٠2�}��@h�j볿$�Q'}��(��~KT>�<'�n���s?���Ǐ���ЖH�F\ĈQ��;�?��b��<}����(5�.-<����`����� �O��%��������'y�����`8��S*��<�s�M���gH�3IV3)���4�����:E�f��?磺�BT����?�dX��q��H:5Ks-!Qo�]�-%�R�?;���BC�d�����n�Me�����OK���4�̲4��dz��*�H\ڡ#�x��i�Azi�y{��Ɋ<y�t�ݒ��:���+�Nh.';f��G�M��k���,�c�L�6w-y�g�d��N����9~�1sw��
��gܺ�c�8������Y<�G��������`����=�ǁ�i����?�������y?7�[��gD�?*�З�Oc�/
�S������k�&�zdF�8��\�),�E���?g4�������-�Ł�i�b�'�s��������:������+�?���(�#�_�_���)T;p��mu���W�iץ�+zr�~��c*�H�&�i�oQ��k��j�$�.�����_����*�ta����5%/oŽP�2赅i��4��<�,��\�q;�2;͚�f���^Qr�v�15h�JCͪ�u��	�^��c�����N�O\���J�ơsBC?xˉ���Ͻ�ą�\������HU��b2+4r��q -P�/5���;Bht�Y�ܰ�/*���]��8+6\�t�q�s
)��MVr���&[DMg��V,5�bc��ܧy��>��&�t�)ȃ��
�JMa���}��yf�<���3d՝�Vk�J�E���Y��鞑K63Ɏ��n,�5��ň*�-B���j@z}�q��(����Q j��?�k�1��?�������?X�������b��c��̀����������������(������q������?n������b����9���8���p3�gM��3,E��>�f�_��pl���S<��Sd��󌞦���ќ��)�O�<�1X���%������!��C,ץ�����K�ੑ1rՙS1z�V����^O&[ke�ۿ�c%�7¦��S��</v�&�ΌYIy�����bm���L�6��<���0�'�	U�1!�5W�R��sOs��]�du4��?ދ8��8��������X��������n��x	P����!��������p�,�E!������?�����?n�����ul�b����7�����}�q����L����x�����g�����>��{:��>��Ƕ��t�����l֭���"���H��û�(?�&FW('��A듭�Y�֮-�Tw���]ͨ��c,�m�Ykw��i�<G�4�Fᬙ,p�pQ�i�E�!����j�5�*��$P}�f׋����D��)�[9�l{CdW�	K�6�H��0���\��]m0̬A��ܦ��Yb�'s�<�vJbeRϚ��iW�u�AUrټ0���b*mu!N�w�nJL����YUJBv�mTf�X)���Ns ��J���iR�,�%+�>�ٞ�7�r�)�ɉ�bB�/�|������9� ����C����/`��s�q���v��c�<���o������������]�Լ���t���$������<���sD������/,�<����,�^�?�������"���FZe5FWuJK�T�3SZ*��ڧ��dtC��E�3)�%3dZː}�53�aYN�Q>>Q���k�?h����?��AM�EU���ݡ�Hׄ�Z}6���V,1��n_��l���T�li׮��ʒ{l��'k3�ՙ��x��F�l<�K�7JY�t�zG��Z=Gv��@�L�Sr����蚃	���v;��?ލ����0��p�ǫ����������c��xF�}{�����H��b�����_#�Ǐ�7^�KD������������$y��,��?D�����O|�́������������7�|č+�?��Q����8�?C]����� .���I>C�3t���5MUY=�r��i�4�T&C��7x2���g�L&���5Sͤ3&���CT��F�/���E�7�kd�|���=��Q�s��]�L/-!mo�읭�Vd�2�Ջ��E�O��Y���/�Z��T��j.s|%-e'Va�۫w��EK�7�Z�gI�\�ɲVؒ�M�Α�F��5�FgN�������w#�?M]��by|�S$�������1������X�?���n����6�-b��Q)�b�G�����G���p��!���Be�Z�v��K���T/'��������������T!���zˆ*�$�bNhy�m�����qSUÕ����F��S���og�`�]r[�{%'��
]��Upm�픱~��z[q/���zmB�v�JSq%o+�,��\�q;�2;͚�f���^Qr�v�15h�JCͪ�u��!BE+���L�(YՑ�U*�.&����m(F$�� ��jKm��;O�ROz�/.�;����8�M��9Cӫau�����q�N3�m�iZ�qb}�)Ϋ�h�=�C��O�*'�l*�>���D8H�����k(H���z�-��nŦ�=�WŤ"N
�U6h��b�ښ�|S�<?��]��&�zq��	w���n���.�b-��D�\VFY��𢺽St��㨒�R��:��Ym�\n�m�Q��؂<0wB�(����]V�������B�&���w�ǩS|�*�|���������7���q7��?���OqX��b��W�b3��#��e����^��u���\hz�Z1%���w+E��d��_�_��(��E9dPNlD�q`����1[��D1'�AѤ3���3�s:b���w��������K�Ta�-8ug�6
���ԫ�TYݒfo\�fV�!�$��3N��ب��m�B��l�5{����΃ ��x�y��O�U�?U����N�I�W-��^�U��Um�RJg��I����ʃ�X/��j�'W�Ūy�[ub�U
5��j;�1Pr��~m�O�?G,�?���|�c$�������1�����X�?se�7��	b����#�B�������������������	>~�N��#�h�w��l�������p���	�c�>����ߨ��,���(����c���7������[!�/e�T��i�������mɮ��l6:�Чd���UOV��E}˶z<�>h[m�r����َ@Q%�6EjHʲ�� 9� �_�@� �E.�=� �9涗{�%��W�)Q_�n�3Qʹ%U�z���}V�ٝV6���v��N2���tj��褶�T<E�V��K����$%[��dj��O���t�O&���y����?���ƾX��}ِZ�q,�v�݆ܖ���/E����������g��m��r�IV�S՛�����Nӱ|'}{Ծ�_�����x~-�Z���c�7/k����t����*�����k��<���O���?�M��MU����]����E�_<��p��=Lz"���퀆s$�f8�ee:'7������-<����R.S4ITz�a��x��c�om���1��d���(�=�ۢ�=�~;��yV;�[u(g����s`S.�[�h)�BK;�cqEo�"��8(ճZ�Zᛥr-��:R ��vDgl����������Ơ\�4����oӁ�ݞ��Y����T<���vE��	(ݭ����t���6Ee��mM��:����fP�1_�'�������۸�����>ጃ%ϑH2
!�5r��o�1-!��.͑�]��.�c6�Hb�f'�̦�	.�ţ�'X�^˺��A1�l�%��B�\l�L��Ũ)��ڬ�*4�4�8�h+,���������G��L� 8�&�B�[Y�da�/��ZX�@1���#��D[�ݖ�c����\kʰO=cĭ��ܲ���[5EY�zS����t�� �vlΙvJ���o=s:}P;-6�|��e"���
U�\��k�ְ;.��J|��5���?nW��l��+u�$_*�xA؋s쿙��)��
_?����s��Ú�&f�4M��=P\�����V��c�ʥ��U~,�/d�p2��~&���Є�)��WQ1fw!�8´��L�]I���Q����,��G�H�\l�j�^�{��G%��akZ $sh���J�I/�[F�Hӯd��l�z�Ĵ��j���]�ue�7lq���7k���fN�Y��#�b,%3�8��}����Mz9�Y�$M��N�bS\�������k�f�9�t�������3��Lř5G�eD��` @��Նd$b�F��_��HKb��-UG�H��j�Д�%�����TrФ��T�%�J�!�*Z�4ƙݝt��qP��+Z0��?Q���f�0_>)VK|����|�\�g��]t.ǚ��z?(�4-_�g~l'������?�Q�V:��O�{CU��/��]�Z�c�P�Y~0gx�0�yʃZ�; �����R�Ӎ38�g^ ��'���|�0X{#���UA(�6�5�yP���pl�5�s�Fc��N����ͭ4�n�a�T4��#J褝��E1��]��fa��ʶ�<cR��E���4�'���(^1oӱ�$+ :.h���D+@D�R
L!90������l�D{`�g1�24���R�x��
�P�xd�~^�U@�����M;�P1�ua���P�k�-���B^��l]4�X=+�
v��/��\%����f�o�p��n��9Q��lf<�8m ~V�E%��4�d��"�Ws���}�)��S:�>"�3g�%�ƎQզ���&D�n?}^<f���c���۽�#��ǳ�6��d!'��Y���J:L�Þ�m*߅���~RC���!�e���0qK8����-a�%L<VK����;ߩ%L��&>���|�ԅ�~ʽ�PѤQ{���\�(�`�w;�JL��&����I�/C�Kr��j�6���L���v�iX$��������D��V_�-b�!�d��Urz#с�.j_EUp�F��X;6q\�8��"B���x�Z�mo#�F#Nd�r�ލ)�;.���&qe�U8Sj7we:ۺ%�.B�d*���]�B��@�H��DmC�#Q���-�.���o���^ 1Q%�@�B��-([��\?׋��k��I���Z�pR*�����O�'�|R�"F��:б@��#I�l�J}$�+ˬ�JrG��kjw�$�j �*]Pp}��5��6�Q�lZ�u�_�P,���b�$3�"R�Iz��9���n� u��@�I^ ��u_u�Y��;���{��x�A�sT�����I0E+6Y�^�_����)2��Z����V��\���e��F��<f9��d���z�1�5	&�?�.�:/�7ɟ��l�/�mވ���"�Ir��h��φ�p�>Հ�k
倰�C� �E�Gy��-�ج{���0ǜ�n�)�����.5Y�h������鱬5g�����&`�#�M���Q?5�nwܦ5ǵ���Xh��a��ڎ ��X�^-Us��V }���c�����!v�[�ȭ���$�Id��F�b5{48��p��b6(R�	��t�ڳ�9(-bΆ]}3p�YE��i�qj����O�ܴo\y�·ES������q��[U
h�M{�b�9H��/B�45r{a�� a]�o �M��P/0?6~6��(n�>"�T&&_�����+}���)1J$�P�5]nJ�`�(�C�(!*y��&bO����>\w�M����W4&�����!���aq4��'���eldz@P�|�#v�hH�y��=���ʡ;�*�_��`y�d�kπټ*X Ca� �ٵ8�t��&ö���f&	�C[C��C� }\�A�AT�on�"�v���uյ(�°�ʄ1���GԎ��w�Q0��
����PQ�ͣ:��/"��/"���!����:��6`kF����]��~8b(g��\=��7G���p޼�싲bi/{��=�H��x��7{�6b��뺦��<�Lf�]�3s	#�֑���v��~�t7��[t��;Ψ�qK�,�V��t�n�>��������M
�4�[mx2#�Yb]T�g��>� ���N����Ʌ�q�H.�'��-����т�p?���APdAA��ΊE^"��3{���n{=	�;�Aa(�62z }�Â���^��'�3v�	Ǉ�:��*�"[@���r�tN��{ny�	F�*�[{`L�ё(�����0�H4��ugtzd��l�i�������>+���m,��#����R�L<��T:��^�y���g����Z�����F6q͢#�`�)��-=e]4�Y06���$J����E�&�:�2��@���.����_l�M���t���B^8l
ճZ��&��.L6�h��6|C�Bo8���p��b�w���&��ݞIZ.�nU\��B���@�]�����2�v& �q&(�����$(8���E��<���:_?�� �����)8$,\4�.C�6u8ޜ!#��Z��-�d��W�9_P-����J0��7���g���1�+ɿIEu�ǖ�����'��y��x���ww9n�Y i,g��+z
��\�E�u�׮���=���&=��$�w�_�8�{��^�t�l����oE9�%�p�u��AT%����>Ɋ����� �?�L��&��$���g�c-�������ӶVV��
��KȚ�Ԍ�]�h_1�`s���a�����E������E2��]�}\�a=
p|p�e�dUB/H�X�f�Q��N�|'ݝ�-PƐ�c���<�'��z�9���:Q��տQ���/��ޅ�����;Y4ul��ƥoo&N���G|���J��^E��שe�[�E�?��L��l6����>X���Ԁ�2pk�5x�8��lT�������$�$_}E��>�zI*'.8	�zG�{�j2�n��cr�wcEp���1X����2<wdܣ����'�^fܘ��{|���;�+X˲�a��v��÷�'�E�&;�cN `ׯ!r�<U��Oi	���q.���/�����߮��'���������{n�<Y<�����O2�����}�7Ga e�Q�����C������?O�X��O���2ɵ�?Hz����'��~����:�Z�'�fBP��M{+&΁K��¦��4Ң��:oy����ϓe���?�^�}��X����?�7���<#5��aOX����`O�:a�C��K����좊�|�]ͷ�2���6L�,* L��*����Ӣ�_������v|���I}����~-�c��oÅ| GIĽ�/�<R�p'V��_jv)`�y�'$t=��'�=�@�uwUēc=m��IbNқc]�	"8����Y�Z��|�sQkfݐ��j���`D��O��M�	���(NJ t}5�cax�/�������j��c�*��D�&��g���UF��P�Zu�Vd�ʝp�M^imMe^L>㎳�{2��T�g�rA�ߵ�~Ĵ��Ͻ6��,������s��"=��{��1���)��+�+�l��D�����	�ϝ���Ά;�Л�Q%��^�K��W��]�T�_��K%�JgVKݯZz~5[��	����/Ux��^������7W������I�@��D[0� l�^V�^������?�,>���Z�̀O����H�����c^����C�$�vNd���FܓV�ғ�}������K��NV[su,8L4�r>�> ��OH�Jz������t�{˽�i��h�/�q�$d��������I������N3���&�\���h�E�K�Rj{��)�^�sc�PʡI����bl�m0�Q9�@z��5%�%͞����X��`Xf�bMZ��F�����	�G�	�2dw`�)��vG��?�J2Ū�v�%ú����+��ʾ[�fB��a����p�Z��]����M��5*�RO�f$��C��(~0U�Y���1.�R`w�5��v�Tan��N��\����`��݉�N;��_�V�&�=3�������2��Z��2� $O0"H���� )��cpW����~����_����e�/����$���xg7iW��Lj����J�2"M튙t+����]�ɶii;!�����)	��{��?1����_�;��?����������M���/���(��и��~u���á߳�z��᧿�i(4~s�����g��y�w��?���?�����႗���b1_���ڏ��yw�����w��F��C����ÞtR�K��eyT�_�N.��9����.����ӇJ�����
o*��A��zaj�˻/O�w����|�hG��v{�l��/\���K�V,Y>y��o����7�~2)m�h/[�w��s�U�<q��mtv���I7����סK���x����.���m~�b�W�J�_�^̿�n�b/{�
�~�!^��������҉�vz��U��CR���ļ�x^�^+��+�Y�����-	����@�z~���?Q.ޤ��zct�=��h��v�ݛӎ�-w���� ����xy��ڑ(6Jt7�9�O�j&syQ:ʗb�ż��?��-`��Q��]���[��ߥ�-k���N����(��ۃ�#��䏡�W��
�J�Ѩ����B����ū�^�@���s�f�2f�I�R���AH��/�ʻ����~)/X Z��n<h�k�J��m�jb��x�������W��)�v�.hG��8��>'��8q>��8N��I����B�@�7�
��J�'$8��V�PA���^�Rp�I&3�;;�v+x�=���?�������=?�ی4�=4��4��d���RXf8-87�ͤ��>'�U��azy��
�UR������)ֵ�jٳk��޳ZR��rp��j�1��t�ޓm=,O�F��ͪ-k��m��ζe�I�BP�>lu;ٜ��(��?�(ʕi�rAS'����j��W������$(���I $�-�U-6�B%�te'OŦ����~��u��-���^q�����Z
���[Qav�@P��`!�U]�]$�t�K�Uv~��;yi�g��.�	J��)� 0.�ej55��-���	~��{\��Ns�qG:ہ���\ЯД�P,lSZ��5oO�ia#�=��f&\�q�zߡc̰>5�b�8�)Ә�&��'J�L3ǹ\<��͈{��p/_��fI<W<>Y�:�֙�+;²>��`b5¦t���op��5�Jv�A�0��Z�4#k���8�km!߶U>) F�0��&Y�>������p����#�,�8���]ה|b�\��rj7̖d��B�nd���|-�+}�23�Z�1d������!����2��	��s3�K�+�!��LȚM��J�R��\<�{Z��Da���.(v^oL���z3ߓ��T�3ezP����&O(<�`��=�`QO,�pa�8�q&W�fbC}$�?��宎畒o��K������DMh��}����D%�o�D��[!�я�b�fϚ�WO,P���S�D^b˹&%I�)%X�[�[���!�;�0�@&V��|��hgj��~Y$�N"��&�0P#l�'� ���߬�C�&=*MP#1˷�D���Jn���Rr�ӛ6�,���w�`���	�E S���L7��q�LYl�R��Ys�;�b����q;o}X��Dr�B[����X������C2�)�K�` �O,l+۶R3F�Q�6 �(��B�BMW�[���!�;����Q?�0ܴ6j{�Y����Tɭ��]Z��bT��R��n(�^�ct�sz#}L[�X�܉�-^Ͷ�O��p$[�t��ea6��f;f�9�o vvI�Xy�#����s����>�zh������P�a7����m���.m��>�y���5Nu�����������1v{<��z���p��Ynn`��v�.C}�����ɝ/���/���-�.��q����m�}g�3������g`�.���Em
m����.l��7�"�ݼ���k��vi�3X����������K��n,j�=�]�_w����Ͷ��?����;]{�:� ��[,n��u�=lN�,�<c��v��������9��] <���f�;��1�����A^��d^>��>����}p=�P�
N�P��]�na>u���ԭH}��;��4Q��d��Nӑ�z0�.�eJ��z9��.}V���#��$Q	s�V�SYԮ�lY���4�Ir1�MRlm��hG�ȝ�F8�-i�����r�T��ZO�T��%%F
B2���!�4�0j*8�
���� @���8���Z��ج�FB�n˽�s8��!���$������Wᢣ���	^��SRI�|%��ݸO�3��<𘎛���)S�B�:�W�%���lG�:z5֩�TC��E(3�|���݁�E����Sf~~�{c�<�S�+��N�)�m9�&��f
�?L4C���'$�]�nj�$�X�(���P�!���m?ڷ�� jl���!=�v:N�/u�|o���$ix��2�~k��DbT"� ���	�	k�Gk�:�&�y��T�|���M�]�(9Pr�ǆP��3�|j\^��}`�Yb��NX�X#�/b��Oo��]X8��+��+�
o������K�#��}AX�I��a�N:�6��[eY�օ#=��DT�%n	���|����dqhT��qT�@����H�'�Y�
,I��jmd��9�d�Q.&C�Qϖ��=̴��f��A�5�9��J
;�'$N�Z%�&���)�wGG&p0���l��<_�Y��2Y��I��B�iɐ.�.O�%�ө�0��V�c!2��	)��"!���tL��푝#Hdͅ�H�n���y3&��f��5`�P�χpU�	�S�8����H�^}f�vKN[/� ��q�S�T��t2��P�S�Lx&%J����8�	f�N�§e�J���:%w�m�E��c��&h�|+��x4�Ǔт-��w`�7ܷ�M�h�wj5���.�������������E�e����a����Κ<Q��p�:�R��`c�a�`��z���~�����������x������O��=�;�h����wCv���`02��v�u��׷�U�IF��?#�W#��}0���ܛo��_���~x���v��˙�/�����y����q�����x=~�q��ֹ�x���V��\���Ϸ�v���7�}��o|��{��o�F�5�����}��>�?�؟7��o�b�v����Hډ��H&�dHډ~������iDH#i'�v"i'�l�}����[�G=�S�*O"��k��z8�����`��N�*x��3�[�X�jc�Gğ���}�!MxC:�� ���~JE:�(9���4����b�5��`c�͝�Z3��V�f-@�К�(9�Ú�{X�{K`��ʜgMÝ�Z;�l�+=C1�Y�K��Z�C�2dȐ!C�2dȐ!C�2dȐ!Cv��?�'a�   