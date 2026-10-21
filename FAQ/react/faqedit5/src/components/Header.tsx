import React from 'react';

export const Header = () => {
    
  return (
    <div style={{display: "flex", alignItems: "center", gap: "20px"}}>
      <a href="https://www.intersystems.com/jp">
        <img src="https://www.intersystems.com/assets/intersystems-logo.png" alt="InterSystems Corporation" style={{width: 200, height: 50, border: 0}} />
      </a>
      <p style={{fontSize: "2.5rem", margin: 0, color: "#0d6efd"}}>FAQ検索(よくあるご質問)</p>
    </div>
  );	
}
export default Header;
