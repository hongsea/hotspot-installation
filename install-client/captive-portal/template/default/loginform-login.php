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
              <img src='../../images/user-icon.png' id='icon' alt='User Icon' />
            </div>

            <h3 class='form-signin-heading'>សូមស្វាគមន៍</h3>
            
            <input type='text' id='user' class='form-control' name='UserName' placeholder='$centerUsername' required='' autofocus=''  autocomplete='off'/>
            <input type='password' id='password' class='form-control ' name='Password' placeholder='$centerPassword' required=''/>
            <input type='hidden' name='button' value='Login'>
            <button id='btnlogin' class='btn btn-lg btn-primary btn-block ' onclick=\'javascript:popUp('$loginpath?res=popup1&uamip=$uamip&uamport=$uamport')\'>រួចរាល់</button>

            <!-- footer -->
            <div id='formFooter'>
            <a href='http://world.koompi.pi'>មីនុយគេហទំព័រ</a>
            </div>
        </form>        
    </div>
</div>
";
