<?php
/*
 *********************************************************************************************************
 * daloRADIUS - RADIUS Web Platform
 * Copyright (C) 2007 - Liran Tal <liran@enginx.com> All Rights Reserved.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 *
 *********************************************************************************************************
 *
 * Authors:     Liran Tal <liran@enginx.com>
 *
 * daloRADIUS edition - fixed up variable definition through-out the code
 * as well as parted the code for the sake of modularity and ability to 
 * to support templates and languages easier.
 * Copyright (C) Enginx and Liran Tal 2007, 2008
 * 
 *********************************************************************************************************
 */
// <script language=\"javascript\">;
// document.getElementById('demo').click();
// </script>

// <hr class='colorgraph'><br>
// <span class='ant-input-suffix'><span role='img' aria-label='eye' tabindex='-1' class='anticon anticon-eye ant-input-password-icon'><svg viewBox='64 64 896 896' focusable='false' class='' data-icon='eye' width='1em' height='1em' fill='currentColor' aria-hidden='true'><path d='M942.2 486.2C847.4 286.5 704.1 186 512 186c-192.2 0-335.4 100.5-430.2 300.3a60.3 60.3 0 000 51.5C176.6 737.5 319.9 838 512 838c192.2 0 335.4-100.5 430.2-300.3 7.7-16.2 7.7-35 0-51.5zM512 766c-161.3 0-279.4-81.8-362.7-254C232.6 339.8 350.7 258 512 258c161.3 0 279.4 81.8 362.7 254C791.5 684.2 673.4 766 512 766zm-4-430c-97.2 0-176 78.8-176 176s78.8 176 176 176 176-78.8 176-176-78.8-176-176-176zm0 288c-61.9 0-112-50.1-112-112s50.1-112 112-112 112 50.1 112 112-50.1 112-112 112z'></path></svg></span></span>

echo "
<div class = 'container'>
    <div class='wrapper'>
        <form action='$loginpath' method='post' name='Login_Form' class='form-signin fadeInDown'>
            <input type='hidden' name='challenge' value='$challenge'>
            <input type='hidden' name='uamip' value='$uamip'>
            <input type='hidden' name='uamport' value='$uamport'>
            <input type='hidden' name='userurl' value='$userurl'>

            <!-- Icon -->
            <div>
              <img src='../../images/KOOMPI-Wifi-1.png' id='icon' alt='User Icon' />
            </div>

            <h3 class='form-signin-heading'>សូមស្វាគមន៍</h3>
            
            <input type='text' id='user' class='form-control' name='UserName' placeholder='$centerUsername' required='' autofocus=''  autocomplete='off'/>
            <input type='password' id='password' class='form-control ' name='Password' placeholder='$centerPassword' required='' action='click'/>
            
            
            <input type='hidden' name='button' value='Login'>
            <button id='btnlogin' class='btn btn-lg btn-primary btn-block ' onclick=\'javascript:popUp('$loginpath?res=popup1&uamip=$uamip&uamport=$uamport')\'>រួចរាល់</button>
            
            <!-- footer -->
            <div id='formFooter'>
            <a href='https://world.DOMAIN'>មីនុយគេហទំព័រ</a>
            </div>
        </form>        
    </div>
</div>
";
