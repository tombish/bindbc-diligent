/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 */
 
/*
 *  Copyright 2019-2021 Diligent Graphics LLC
 *  Copyright 2015-2019 Egor Yusov
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *  
 *      http://www.apache.org/licenses/LICENSE-2.0
 *  
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  In no event and under no legal theory, whether in tort (including negligence), 
 *  contract, or otherwise, unless required by applicable law (such as deliberate 
 *  and grossly negligent acts) or agreed to in writing, shall any Contributor be
 *  liable for any damages, including any direct, indirect, special, incidental, 
 *  or consequential damages of any character arising as a result of this License or 
 *  out of the use or inability to use the software (including but not limited to damages 
 *  for loss of goodwill, work stoppage, computer failure or malfunction, or any and 
 *  all other commercial damages or losses), even if such Contributor has been advised 
 *  of the possibility of such damages.
 */

module bindbc.diligent.graphics.d3d11.textured3d11;

/// \file
/// Definition of the Diligent::ITextureD3D11 interface

import bindbc.diligent.graphics.texture;

// {F3A84CC2-E485-4E72-A08A-437D7FFBA3AB}
static const INTERFACE_ID IID_TextureD3D11 =
    INTERFACE_ID(0xf3a84cc2, 0xe485, 0x4e72, [0xa0, 0x8a, 0x43, 0x7d, 0x7f, 0xfb, 0xa3, 0xab]);

/// Exposes Direct3D11-specific functionality of a texture object.
struct ITextureD3D11Methods
{
    /// Returns a pointer to the ID3D11Resource interface of the internal Direct3D11 object.

    /// The method does *NOT* increment the reference counter of the returned object,
    /// so Release() must not be called.
    ID3D11Resource** GetD3D11Texture(ITextureD3D11*);
}

struct ITextureD3D11Vtbl { ITextureD3D11Methods TextureD3D11; }
struct ITextureD3D11 { ITextureD3D11Vtbl* pVtbl; }

ID3D11Resource** ITextureD3D11_GetD3D11Texture(ITextureD3D11* texture) {
    return texture.pVtbl.TextureD3D11.GetD3D11Texture(texture);
}