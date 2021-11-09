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

module bindbc.diligent.graphics.opengl.querygl;

/// \file
/// Definition of the Diligent::IQueryGL interface

import bindbc.diligent.graphics.query;

// {D8A02AB7-0720-417D-AA9B-20A2C05A3EE0}
static const INTERFACE_ID IID_QueryGL =
    INTERFACE_ID(0xd8a02ab7, 0x720, 0x417d, [0xaa, 0x9b, 0x20, 0xa2, 0xc0, 0x5a, 0x3e, 0xe0]);

/// Exposes OpenGL-specific functionality of a Query object.
struct IQueryGLMethods
{
    /// Returns OpenGL handle of an internal query object.
    GLuint* GetGlQueryHandle(IQueryGL* query);
}

struct IQueryGLVtbl { IQueryGLMethods QueryGL; }
struct IQueryGL { IQueryGLVtbl* pVtbl; }

GLuint* IQueryGL_GetGlQueryHandle(IQueryGL* query) {
    return query.pVtbl.QueryGL.GetGlQueryHandle(query);
}