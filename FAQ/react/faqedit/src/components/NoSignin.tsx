import { useEffect } from "react";
import { useNavigate } from "react-router-dom";

export default function NoSignin() {

const navigate = useNavigate();
    
useEffect( () => {
  localStorage.clear();
  localStorage.setItem('username','_system');
  localStorage.setItem('password','SYS');
  localStorage.setItem('edit','0');
  navigate("/Home",  { state: {username: '_system', password: 'SYS', edit: 0}});
  // eslint-disable-next-line react-hooks/exhaustive-deps
}, []);   

return (
<></>
  );
}