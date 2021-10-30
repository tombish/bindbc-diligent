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

module bindbc.diligent.graphics.opengl.texturegl;

/// \file
/// Definition of the Diligent::ITextureGL interface

#include "../../GraphicsEngine/interface/Texture.h"

// {D7BC9FF0-28F0-4636-9732-710C204D1D63}
static const INTERFACE_ID IID_TextureGL =
    {0xd7bc9ff0, 0x28f0, 0x4636, {0x97, 0x32, 0x71, 0xc, 0x20, 0x4d, 0x1d, 0x63}};

#define DILIGENT_INTERFACE_NAME ITextureGL
#include "../../../Primitives/interface/DefineInterfaceHelperMacros.h"

#define ITextureGLInclusiveMethods \
    ITextureInclusiveMethods;      \
    ITextureGLMethods TextureGL

/// Exposes OpenGL-specific functionality of a texture object.
DILIGENT_BEGIN_INTERFACE(ITextureGL, ITexture)
{
    /// Returns OpenGL texture handle
    VIRTUAL GLuintGetGLTextureHandle(THIS) PURE;

    /// Returns bind target of the native OpenGL texture
    VIRTUAL GLenumGetBindTarget(THIS) CONST PURE;
};
DILIGENT_END_INTERFACE

#include "../../../Primitives/interface/UndefInterfaceHelperMacros.h"

#if DILIGENT_C_INTERFACE

#    define ITextureGL_GetGLTextureHandle(This) CALL_IFACE_METHOD(TextureGL, GetGLTextureHandle, This)
#    define ITextureGL_GetBindTarget(This)      CALL_IFACE_METHOD(TextureGL, GetBindTarget,      This)

#endif


