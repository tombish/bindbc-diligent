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

module bindbc.diligent.graphics.engine.enginefactory;

/// \file
/// Defines Diligent::IEngineFactory interface

import bindbc.diligent.primitives.object;
import bindbc.diligent.graphics.graphicstypes;

version(Android) {
    struct ANativeActivity;
    struct AAssetManager;
}

struct IShaderSourceInputStreamFactory;

// {D932B052-4ED6-4729-A532-F31DEEC100F3}
static const INTERFACE_ID IID_EngineFactory =
    INTERFACE_ID(0xd932b052, 0x4ed6, 0x4729, [0xa5, 0x32, 0xf3, 0x1d, 0xee, 0xc1, 0x0, 0xf3]);

/// Engine factory base interface
struct IEngineFactoryMethods
{
    extern(C) @nogc nothrow {
        /// Returns API info structure, see Diligent::APIInfo.
        const APIInfo** GetAPIInfo(IEngineFactory*);

        /// Creates default shader source input stream factory

        /// \param [in]  SearchDirectories           - Semicolon-seprated list of search directories.
        /// \param [out] ppShaderSourceStreamFactory - Memory address where the pointer to the shader source stream factory will be written.
        void* CreateDefaultShaderSourceStreamFactory(
                            IEngineFactory*,
                            const(char)*                              SearchDirectories,
                            IShaderSourceInputStreamFactory** ppShaderSourceFactory);

        /// Enumerates adapters available on this machine.

        /// \param [in]     MinVersion  - Minimum required API version (feature level for Direct3D).
        /// \param [in,out] NumAdapters - The number of adapters. If Adapters is null, this value
        ///                               will be overwritten with the number of adapters available
        ///                               on this system. If Adapters is not null, this value should
        ///                               contain the maximum number of elements reserved in the array
        ///                               pointed to by Adapters. In the latter case, this value
        ///                               is overwritten with the actual number of elements written to
        ///                               Adapters.
        /// \param [out]    Adapters - Pointer to the array conataining adapter information. If
        ///                            null is provided, the number of available adapters is
        ///                            written to NumAdapters.
        ///
        /// \note OpenGL backend only supports one device; features and properties will have limited information.
        void* EnumerateAdapters(IEngineFactory*,
                                Version              MinVersion,
                                uint*                NumAdapters,
                                GraphicsAdapterInfo* Adapters);

        version(Android) {
            /// On Android platform, it is necessary to initialize the file system before
            /// CreateDefaultShaderSourceStreamFactory() method can be called.

            /// \param [in] NativeActivity          - Pointer to the native activity object (ANativeActivity).
            /// \param [in] NativeActivityClassName - Native activity class name.
            /// \param [in] AssetManager            - Pointer to the asset manager (AAssetManager).
            ///
            /// \remarks See AndroidFileSystem::Init.
            void* InitAndroidFileSystem(IEngineFactory*,
                                                    ANativeActivity*  NativeActivity,
                                                    const(char)*      NativeActivityClassName,
                                                    AAssetManager*    AssetManager);
        }
    }
}

struct IEngineFactoryVtbl { IEngineFactoryMethods EngineFactory; }
struct IEngineFactory { IEngineFactoryVtbl* pVtbl; }


const APIInfo** IEngineFactory_GetAPIInfo(IEngineFactory* factory) {
    return factory.pVtbl.EngineFactory.GetAPIInfo(factory);
}

void* IEngineFactory_CreateDefaultShaderSourceStreamFactory(IEngineFactory* factory, const(char)* searchDirectories, IShaderSourceInputStreamFactory** ppShaderSourceFactory) {
    return factory.pVtbl.EngineFactory.CreateDefaultShaderSourceStreamFactory(factory, searchDirectories, ppShaderSourceFactory);
}

void* IEngineFactory_EnumerateAdapters(IEngineFactory* factory, Version minVersion, uint* numAdapters, GraphicsAdapterInfo* adapters) {
    return factory.pVtbl.EngineFactory.EnumerateAdapters(factory, minVersion, numAdapters, adapters);
}

void* IEngineFactory_InitAndroidFileSystem(IEngineFactory* factory, ANativeActivity* nativeActivity, const(char)* nativeActivityClassName, AAssetManager* assetManager) {
    return factory.pVtbl.EngineFactory.InitAndroidFileSystem(factory, nativeActivity, nativeActivityClassName, assetManager);
}