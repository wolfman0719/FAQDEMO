import React from 'react';

export const Header = () => {
    
  return (
    <div style={{ display: "flex", alignItems: "center", gap: "24px" }}>
      <a href="https://www.intersystems.co.jp"><img src="https://www.intersystems.com/assets/intersystems-logo.png" alt="InterSystems Corporation" style={{ width: "200px", height: "50px", border: "0" }} /></a>
      <p className="blue-text text-darken-2" style={{ fontSize: "2.5rem", margin: 0 }}>FAQ検索（よくあるご質問）</p>
    </div>
  );	
}
export default Header;
