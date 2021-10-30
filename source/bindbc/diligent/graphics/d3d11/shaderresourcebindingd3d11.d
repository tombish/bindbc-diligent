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

module bindbc.diligent.graphics.d3d11.shaderresourcebindingd3d11;

/// \file
/// Definition of the Diligent::IShaderResourceBindingD3D11 interface and related data structures

import bindbc.diligent.graphics.shaderresourcebinding;

// {97A6D4AC-D4AF-4AA9-B46C-67417B89026A}
static const INTERFACE_ID IID_ShaderResourceBindingD3D11 =
    INTERFACE_ID(0x97a6d4ac, 0xd4af, 0x4aa9, [0xb4, 0x6c, 0x67, 0x41, 0x7b, 0x89, 0x2, 0x6a]);

struct IShaderResourceBindingD3D11Vtbl { }

struct IShaderResourceBindingD3D11
{
    IShaderResourceBindingD3D11Vtbl* pVtbl;
}
