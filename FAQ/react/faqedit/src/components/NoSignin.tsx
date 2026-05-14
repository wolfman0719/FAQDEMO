import { useEffect } from "react";
import { useNavigate } from "react-router-dom";
import configinfo from '../serverconfig.json';

export default function NoSignin() {

const navigate = useNavigate();

const username = configinfo.Username;
const password = configinfo.Password;
    
useEffect( () => {  
  navigate("/Home",  { state: {username: username, password: password, edit: '0'}});
  // eslint-disable-next-line react-hooks/exhaustive-deps
}, []);   

return (
<></>
  );
}